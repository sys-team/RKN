create or replace function rkn.isBlocked(
    @ip STRING
) returns integer
begin

    if exists(
        select *
        from rkn.Blocked
        where rkn.ip2bigint(@ip) between startIP and endIP
            and isDeleted = 0
    ) then

        return 1;

    end if;

    return 0;

end
;
