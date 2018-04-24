create or replace function rkn.bit2bigint(
    @bit STRING
) returns bigint
begin
    declare @result bigint;
    declare @i integer;
    declare @s STRING;

    set @result = 0;
    set @s = left(@bit, 1);
    set @bit = substring(@bit, 2);

    while isnull(@s , '') <> '' loop

        set @result = @result * 2 + cast(@s as integer);
        set @s = left(@bit, 1);
        set @bit = substring(@bit, 2);

    end loop;

    return @result;

    exception
        when others then
            return null;

end
;
