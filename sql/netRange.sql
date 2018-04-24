create or replace procedure rkn.netRange(
    @net STRING
)
begin
    declare @stringMask STRING;
    declare @bitMask bigint;
    declare @mask bigint;
    declare @metric integer;
    declare @startIP bigint;
    declare @endIP bigint;

    set @mask = rkn.ip2bigint(@net);
    set @metric = regexp_substr(@net, '(?<=/)[0-9]*');

    set @stringMask = replicate('1', @metric) + replicate('0', 32 -@metric);
    set @bitMask = rkn.bit2bigint(@stringMask);

    -- message 'rkn.netRange @stringMask = ', @stringMask to client;
    -- message 'rkn.netRange @bitMask = ',  @bitMask to client;

    set @startIP = @mask & @bitMask;

    set @stringMask = replicate('0', @metric) + replicate('1', 32 -@metric);
    set @bitMask = rkn.bit2bigint(@stringMask);

    -- message 'rkn.netRange @stringMask = ', @stringMask to client;
    -- message 'rkn.netRange @bitMask = ',  @bitMask to client;

    set @endIP = @startIP | @bitMask;

    select @startIP as startIP,
        @endIP as endIP;

end
;
