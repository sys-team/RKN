create or replace procedure rkn.blockRule(
    @ip STRING
)
begin

    select mask
    from rkn.Blocked
    where rkn.ip2bigint(@ip) between startIP and endIP
        and isDeleted = 0;

end
;
