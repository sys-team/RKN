grant connect to rkn;
grant dba to rkn;

create global temporary table rkn.File(

    data STRING,
    updated varchar(128),

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)

)  not transactional share by all
;

create global temporary table rkn.RawData(

    a STRING,
    b STRING,
    c STRING,
    d STRING,
    e STRING,
    f STRING

) not transactional share by all
;

create global temporary table rkn.Blocked(

    mask STRING,
    startIP bigint,
    endIP bigint,

    isDeleted integer default 0,

    id ID, xid GUID, ts TS, cts CTS,
    unique (xid), primary key (id)

)  not transactional share by all
;
create index xk_Blocked_startIp on rkn.Blocked(startIP)
;
