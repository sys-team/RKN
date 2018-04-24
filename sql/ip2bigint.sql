create or replace function rkn.ip2bigint(
    @ip STRING
) returns bigint
begin
    declare @result bigint;

    set @result = cast(regexp_substr(@ip, '[0-9]*') as integer);
    set @result = @result * 256
        + cast(regexp_substr(@ip, '(?<=\.)[0-9]*') as integer);
    set @result = @result * 256
        + cast(regexp_substr(@ip, '(?<=\.)[0-9]*', 0, 2) as integer);
    set @result = @result * 256
        + cast(regexp_substr(@ip, '(?<=\.)[0-9]*', 0, 3) as integer);

    return @result;

exception
    when others then
        return null;

end
;
