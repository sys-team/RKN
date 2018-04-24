create or replace procedure rkn.setBlockedRange()
begin
    declare @ipRe STRING;
    declare @netRe STRING;

    set @ipRe = string(
        '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.',
        '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.',
        '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.',
        '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
    );

    set @netRe = @ipRe + '/[0-9]*';

    update rkn.Blocked
    set startIP = rkn.ip2bigint(mask),
        endIP = rkn.ip2bigint(mask)
    where mask regexp @ipRe
        and startIP is null;

    update rkn.Blocked
    set startIP = r.startIP,
        endIP = r.endIP
    from rkn.Blocked bl outer apply rkn.netRange(mask) r
    where mask regexp @netRe
        and bl.startIP is null;

end
;
