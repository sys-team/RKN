create or replace procedure rkn.refreshData(
    @url STRING default 'https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv'
)
begin
    declare @updated STRING;
    declare @data STRING;
    declare @ipRe STRING;
    declare @netRe STRING;

    declare local temporary table #r(
        mask STRING
    );

    set @data = util.httpsRequest(
        @url,
        'HTTP:GET',
        null,
        'cert_name=github'
    );

    set @data = csconvert(@data, 'db_charset', 'windows-1251');

    set @updated = (
        select str
        from openstring(value @data)
            with(
                str STRING
            )
            option (
                delimited by ';'
            ) as t
        where str like 'Updated: %'
    );

    if not exists(
        select *
        from rkn.File
        where updated = @updated
    )
    and @updated is not null then

        insert into rkn.File on existing update with auto name
        select 1 as id,
            @updated as updated,
            @data as data;

        delete from rkn.RawData;

        insert into rkn.RawData with auto name
        select a,
            b,
            c,
            d,
            e,
            f
        from openstring(value @data)
            with(
                a STRING,
                b STRING,
                c STRING,
                d STRING,
                e STRING,
                f STRING
            )
            option (
                delimited by ';'
            ) as t;

        insert into #r with auto name
        select trim(row_value) as mask
        from rkn.RawData outer apply sa_split_list(a, '|');

        set @ipRe = string(
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.',
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.',
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.',
            '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
        );

        set @netRe = @ipRe + '/[0-9]*';

        delete from #r
        where mask not regexp @ipRe
            and mask not regexp @netRe;

        if not exists(
            select *
            from #r
        ) then

            return;

        end if;

        merge into rkn.Blocked t using with auto name (
            select mask
            from #r
        ) as d on t.mask = d.mask
        when not matched then insert
        when matched then skip;

        update rkn.Blocked
        set isDeleted = 1
        where mask not in (
            select mask
            from #r
        );

        call rkn.setBlockedRange();

    end if;


end
;
