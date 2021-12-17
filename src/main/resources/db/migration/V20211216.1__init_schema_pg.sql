DROP TABLE IF EXISTS "public"."account_record";

CREATE TABLE "public"."account_record"
(
    "id"              serial8 PRIMARY KEY NOT NULL,
    "user_id"         varchar             NOT NULL,
    "account_id"      varchar             NOT NULL,
    "account_name"    varchar,
    "account_type"    int8                NOT NULL,
    "status"          varchar             NOT NULL,
    "account_class"   int4,
    "live_mode"       int4,
    "contract_time"   timestamp(3),
    "expiration_time" timestamp(3),
    "created_at"      timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"      timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE "public"."account_record"
    ADD CONSTRAINT "uk_ar_accountid" UNIQUE ("account_id");
ALTER TABLE "public"."account_record"
    ADD CONSTRAINT "uk_ar_userid_accounttype" UNIQUE ("user_id", "account_type");

COMMENT
ON TABLE "public"."account_record" IS 'account information';
COMMENT
ON COLUMN "public"."account_record".id IS 'pk';
COMMENT
ON COLUMN "public"."account_record".user_id IS 'unique identification of accounting system';
COMMENT
ON COLUMN "public"."account_record".account_type IS 'used to identify each account type';
COMMENT
ON COLUMN "public"."account_record".account_class IS '0:corporate account | 1:private account';
COMMENT
ON COLUMN "public"."account_record".live_mode IS 'account mode 0:test mode | 1:live mode';
COMMENT
ON COLUMN "public"."account_record".status IS '000000: available';

DROP TABLE IF EXISTS "public"."account_type_config";
CREATE TABLE "public"."account_type_config"
(
    "id"               serial8 PRIMARY KEY NOT NULL,
    "account_type"     int8                NOT NULL,
    "account_class"    int4                NOT NULL,
    "sub_account_type" int8                NOT NULL,
    "dc_flag"          varchar(1)          NOT NULL,
    "status"           int2,
    "description"      varchar,
    "created_at"       timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"       timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."account_type_config"
    ADD CONSTRAINT "uk_atc_accounttype_accountclass_subaccounttype" UNIQUE ("account_type", "account_class", "sub_account_type");

COMMENT
ON TABLE "public"."account_type_config" IS 'Account Type Configuration';
COMMENT
ON COLUMN "public"."account_type_config".id IS 'pk';
COMMENT
ON COLUMN "public"."account_type_config".account_type IS '账户类型，0:收单账户，1:存款账户';
COMMENT
ON COLUMN "public"."account_type_config".account_class IS '账户分类，0:corporate account | 1:private account';
COMMENT
ON COLUMN "public"."account_type_config".sub_account_type IS '子账户类型，0:cash balance 1:in the settlement 2:cash deposit 3:owe balance';
COMMENT
ON COLUMN "public"."account_type_config".dc_flag IS '账户余额借贷标识 D:debit C:credit';



DROP TABLE IF EXISTS "public"."accounting_detail_cache";
CREATE TABLE "public"."accounting_detail_cache"
(
    "id"                serial8 PRIMARY KEY NOT NULL,
    "account_detail_id" varchar             NOT NULL,
    "account_id"        varchar             NOT NULL,
    "sub_account_type"  int8                NOT NULL,
    "batch_id"          varchar,
    "sub_account_id"    varchar             NOT NULL,
    "process_mode"      varchar             NOT NULL,
    "status"            int4                NOT NULL DEFAULT 0,
    "user_id"           varchar             NOT NULL,
    "account_order_id"  varchar             NOT NULL,
    "outer_order_id"    varchar             NOT NULL,
    "amount"            numeric             NOT NULL,
    "currency"          varchar             NOT NULL,
    "dc_flag"           varchar(1)          NOT NULL,
    "account_dc_flag"   varchar(1)          NOT NULL,
    "service_code"      varchar(10),
    "suite_no"          int4,
    "rule_code"         varchar,
    "direction_flag"    int4                NOT NULL,
    "accounting_date"   date,
    "business_time"     timestamp(3),
    "created_at"        timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"        timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;


CREATE INDEX "idx_adc_accountorderid" ON "public"."accounting_detail_cache" (
                                                                             "account_order_id"
    );
CREATE INDEX "idx_adc_status" ON "public"."accounting_detail_cache" (
                                                                     "status"
    );
ALTER TABLE "public"."accounting_detail_cache"
    ADD CONSTRAINT "uk_adc_accountdetailid" UNIQUE ("account_detail_id");

COMMENT
ON TABLE "public"."accounting_detail_cache" IS '缓冲记账明细';
COMMENT
ON COLUMN "public"."accounting_detail_cache".id IS 'pk';
COMMENT
ON COLUMN "public"."accounting_detail_cache".account_detail_id IS '账务明细ID，唯一索引';
COMMENT
ON COLUMN "public"."accounting_detail_cache".sub_account_type IS '子账户类型，sub_account_record表sub_account_type';
COMMENT
ON COLUMN "public"."accounting_detail_cache".sub_account_id IS '子账户编号，sub_account_record表sub_account_id';
COMMENT
ON COLUMN "public"."accounting_detail_cache".account_order_id IS '记账订单ID，account_order 表account_order_id';
COMMENT
ON COLUMN "public"."accounting_detail_cache".outer_order_id IS '外部订单号，业务系统调用提交订单号';
COMMENT
ON COLUMN "public"."accounting_detail_cache".dc_flag IS '借贷标识 D:debit C:credit';
COMMENT
ON COLUMN "public"."accounting_detail_cache".account_dc_flag IS '账户余额借贷标识,sub_account_record 表dc_flag, D:debit C:credit';
COMMENT
ON COLUMN "public"."accounting_detail_cache".direction_flag IS 'direction of balance | 1: increase -1: decrease';
COMMENT
ON COLUMN "public"."accounting_detail_cache".accounting_date IS '会计日，会计日切';
COMMENT
ON COLUMN "public"."accounting_detail_cache".business_time IS '业务发生时间';



-- ----------------------------
-- Table structure for accounting_detail_record
-- ----------------------------
DROP TABLE IF EXISTS "public"."accounting_detail_record";
CREATE TABLE "public"."accounting_detail_record"
(
    "id"                serial8 PRIMARY KEY NOT NULL,
    "account_detail_id" varchar             NOT NULL,
    "account_id"        varchar             NOT NULL,
    "sub_account_id"    varchar             NOT NULL,
    "sub_account_type"  int8                NOT NULL,
    "user_id"           varchar             NOT NULL,
    "account_order_id"  varchar             NOT NULL,
    "outer_order_id"    varchar             NOT NULL,
    "amount"            numeric             NOT NULL,
    "currency"          varchar             NOT NULL,
    "dc_flag"           varchar(1)          NOT NULL,
    "account_dc_flag"   varchar(1)          NOT NULL,
    "service_code"      varchar(10),
    "suite_no"          int4,
    "rule_code"         varchar,
    "direction_flag"    int4                NOT NULL,
    "accounting_date"   date,
    "business_time"     timestamp(3),
    "created_at"        timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"        timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

ALTER TABLE "public"."accounting_detail_record"
    ADD CONSTRAINT "uk_adr_accountdetailid" UNIQUE ("account_detail_id");

CREATE INDEX "idx_adr_accountorderid" ON "public"."accounting_detail_record" (
                                                                              "account_order_id"
    );
CREATE INDEX "idx_adr_outerorderid" ON "public"."accounting_detail_record" (
                                                                            "outer_order_id"
    );

COMMENT
ON TABLE "public"."accounting_detail_record" IS '账务明细';
COMMENT
ON COLUMN "public"."accounting_detail_record".id IS 'pk';
COMMENT
ON COLUMN "public"."accounting_detail_record".account_detail_id IS '账务明细ID，唯一索引';
COMMENT
ON COLUMN "public"."accounting_detail_record".sub_account_type IS '子账户类型，sub_account_record表sub_account_type';
COMMENT
ON COLUMN "public"."accounting_detail_record".sub_account_id IS '子账户编号，sub_account_record表sub_account_id';
COMMENT
ON COLUMN "public"."accounting_detail_record".account_order_id IS '记账订单ID，account_order 表account_order_id';
COMMENT
ON COLUMN "public"."accounting_detail_record".outer_order_id IS '外部订单号，业务系统调用提交订单号';
COMMENT
ON COLUMN "public"."accounting_detail_record".dc_flag IS '借贷标识 D:debit C:credit';
COMMENT
ON COLUMN "public"."accounting_detail_record".account_dc_flag IS '账户余额借贷标识,sub_account_record 表dc_flag, D:debit C:credit';
COMMENT
ON COLUMN "public"."accounting_detail_record".direction_flag IS 'direction of balance | 1: increase -1: decrease';
COMMENT
ON COLUMN "public"."accounting_detail_record".accounting_date IS '会计日，会计日切';
COMMENT
ON COLUMN "public"."accounting_detail_record".business_time IS '业务发生时间';


-- ----------------------------
-- Table structure for accounting_mode_rule
-- ----------------------------
DROP TABLE IF EXISTS "public"."accounting_mode_rule";
CREATE TABLE "public"."accounting_mode_rule"
(
    "id"              serial8 PRIMARY KEY NOT NULL,
    "service_code"    varchar             NOT NULL,
    "accounting_mode" varchar             NOT NULL,
    "rule_script"     varchar             NOT NULL,
    "rule_type"       varchar,
    "status"          int4                NOT NULL,
    "remark"          varchar,
    "created_at"      timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"      timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

CREATE INDEX "idx_amr_servicecode" ON "public"."accounting_mode_rule" (
                                                                       "service_code"
    );

COMMENT
ON TABLE "public"."accounting_mode_rule" IS '记账模式配置';
-- ----------------------------
-- Table structure for accounting_order
-- ----------------------------
DROP TABLE IF EXISTS "public"."accounting_order";
CREATE TABLE "public"."accounting_order"
(
    "id"               serial8 PRIMARY KEY NOT NULL,
    "outer_order_id"   varchar             NOT NULL,
    "account_order_id" varchar             NOT NULL,
    "service_code"     varchar             NOT NULL,
    "status"           int4                NOT NULL,
    "merchant_no"      varchar,
    "sys_flag"         varchar,
    "created_at"       timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"       timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

ALTER TABLE "public"."accounting_order"
    ADD CONSTRAINT "uk_ao_accountorderid" UNIQUE ("account_order_id");
ALTER TABLE "public"."accounting_order"
    ADD CONSTRAINT "uk_ao_outerorderid" UNIQUE ("outer_order_id");


COMMENT
ON TABLE "public"."accounting_order" IS '记账订单';
COMMENT
ON COLUMN "public"."accounting_order".id IS 'pk';
COMMENT
ON COLUMN "public"."accounting_order".account_order_id IS '记账订单ID，账务系统生成';
COMMENT
ON COLUMN "public"."accounting_order".outer_order_id IS '外部订单号，业务系统调用提交订单号';
COMMENT
ON COLUMN "public"."accounting_order".service_code IS '业务编码';
COMMENT
ON COLUMN "public"."accounting_order".status IS '0:fulfill 1:cache';
COMMENT
ON COLUMN "public"."accounting_order".merchant_no IS '所属商户';
COMMENT
ON COLUMN "public"."accounting_order".sys_flag IS '订单来源系统标识';


-- ----------------------------
-- Table structure for accounting_rule_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."accounting_rule_config";
CREATE TABLE "public"."accounting_rule_config"
(
    "id"                 serial8 PRIMARY KEY NOT NULL,
    "service_code"       varchar             NOT NULL,
    "service_name"       varchar,
    "rule_code"          varchar             NOT NULL,
    "rule_name"          varchar,
    "status"             varchar             NOT NULL,
    "suite_no"           int4,
    "party_role"         varchar             NOT NULL,
    "user_id"            varchar,
    "account_type"       int4,
    "currency"           varchar,
    "default_account_id" varchar,
    "pricing_expression" varchar,
    "dc_flag"            varchar,
    "remark"             varchar,
    "created_at"         varchar             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"         varchar             NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
CREATE INDEX "idx_arc_servicecode" ON "public"."accounting_rule_config" (
                                                                         "service_code"
    );
ALTER TABLE "public"."accounting_rule_config"
    ADD CONSTRAINT "uk_arc_rulecode" UNIQUE ("rule_code");


COMMENT
ON TABLE "public"."accounting_rule_config" IS '记账规则配置';
COMMENT
ON COLUMN "public"."accounting_rule_config".id IS 'pk';
COMMENT
ON COLUMN "public"."accounting_rule_config".party_role IS 'payee,payer,split';

-- ----------------------------
-- Table structure for accounting_service_config
-- ----------------------------
DROP TABLE IF EXISTS "public"."accounting_service_config";
CREATE TABLE "public"."accounting_service_config"
(
    "id"           serial8 PRIMARY KEY NOT NULL,
    "service_code" varchar             NOT NULL,
    "service_name" varchar,
    "status"       int2                NOT NULL,
    "expired_time" date,
    "description"  varchar,
    "created_at"   varchar             NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"   varchar             NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
CREATE INDEX "idx_asc_servicecode_status" ON "public"."accounting_service_config" (
                                                                                   "service_code",
                                                                                   "status"
    );

ALTER TABLE "public"."accounting_service_config"
    ADD CONSTRAINT "uk_asc_servicecode" UNIQUE ("service_code");

-- ----------------------------
-- Table structure for freeze_detail_record
-- ----------------------------
DROP TABLE IF EXISTS "public"."freeze_detail_record";
CREATE TABLE "public"."freeze_detail_record"
(
    "id"                         serial8 PRIMARY KEY NOT NULL,
    "account_detail_id"          varchar             NOT NULL,
    "original_account_detail_id" varchar,
    "account_id"                 varchar             NOT NULL,
    "sub_account_id"             varchar             NOT NULL,
    "sub_account_type"           int8                NOT NULL,
    "user_id"                    varchar             NOT NULL,
    "type"                       int4                NOT NULL,
    "status"                     int4                NOT NULL,
    "account_order_id"           varchar             NOT NULL,
    "outer_order_id"             varchar             NOT NULL,
    "amount"                     numeric             NOT NULL,
    "currency"                   varchar             NOT NULL,
    "service_code"               varchar             NOT NULL,
    "after_balance"              numeric,
    "accounting_date"            date,
    "business_time"              timestamp(3),
    "created_at"                 timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"                 timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

CREATE INDEX "idx_fdr_accountorderid_type" ON "public"."freeze_detail_record" (
                                                                               "account_order_id",
                                                                               "type"
    );
ALTER TABLE "public"."freeze_detail_record"
    ADD CONSTRAINT "uk_fdr_accountdetailid" UNIQUE ("account_detail_id");


COMMENT
ON TABLE "public"."freeze_detail_record" IS '账务冻结记录';
COMMENT
ON COLUMN "public"."freeze_detail_record".id IS 'pk';
COMMENT
ON COLUMN "public"."freeze_detail_record".account_detail_id IS '记账流水号';
COMMENT
ON COLUMN "public"."freeze_detail_record".original_account_detail_id IS '原记账流水号，解冻流水时存在该数据';
COMMENT
ON COLUMN "public"."freeze_detail_record".type IS '业务类型 0:freeze 1:unfreeze';
COMMENT
ON COLUMN "public"."freeze_detail_record".status IS '状态 0:freezed 1:unfreezed';
COMMENT
ON COLUMN "public"."freeze_detail_record".account_order_id IS 'account_order 表account_order_id';
COMMENT
ON COLUMN "public"."freeze_detail_record".outer_order_id IS '外部请求流水号';

-- ----------------------------
-- Table structure for sub_account_record
-- ----------------------------
DROP TABLE IF EXISTS "public"."sub_account_record";
CREATE TABLE "public"."sub_account_record"
(
    "id"               serial8 PRIMARY KEY NOT NULL,
    "user_id"          varchar             NOT NULL,
    "account_id"       varchar             NOT NULL,
    "sub_account_id"   varchar             NOT NULL,
    "sub_account_type" int8                NOT NULL,
    "status"           varchar             NOT NULL,
    "balance"          numeric             NOT NULL,
    "freeze_balance"   numeric             NOT NULL,
    "currency"         varchar             NOT NULL,
    "account_class"    int2                NOT NULL,
    "dc_flag"          varchar             NOT NULL,
    "accounting_code"  varchar,
    "last_update_id"   int2,
    "accounting_date"  date,
    "sign"             varchar,
    "created_at"       timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"       timestamp(3)        NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

CREATE INDEX "idx_sar_userid" ON "public"."sub_account_record" (
                                                                "user_id"
    );

ALTER TABLE "public"."sub_account_record"
    ADD CONSTRAINT "uk_sar_subaccountid" UNIQUE ("sub_account_id");
ALTER TABLE "public"."sub_account_record"
    ADD CONSTRAINT "uk_sar_accountid_subaccounttype_currency" UNIQUE ("account_id", "sub_account_type", "currency");

COMMENT
ON TABLE "public"."sub_account_record" IS 'subaccount information';
COMMENT
ON COLUMN "public"."sub_account_record".id IS 'pk';
COMMENT
ON COLUMN "public"."sub_account_record".user_id IS 'unique identification of accounting system';
COMMENT
ON COLUMN "public"."sub_account_record".account_id IS 'account_record 表 account_id';
COMMENT
ON COLUMN "public"."sub_account_record".sub_account_id IS '子账户ID';
COMMENT
ON COLUMN "public"."sub_account_record".account_class IS '账户分类，0:corporate account | 1:private account';
COMMENT
ON COLUMN "public"."sub_account_record".sub_account_type IS '子账户类型，0:cash balance 1:in the settlement 2:cash deposit 3:owe balance';
COMMENT
ON COLUMN "public"."sub_account_record".dc_flag IS '账户余额借贷标识 D:debit C:credit';
COMMENT
ON COLUMN "public"."sub_account_record".status IS '000000: available';
COMMENT
ON COLUMN "public"."sub_account_record".sign IS '账户签名';
COMMENT
ON COLUMN "public"."sub_account_record".accounting_code IS '会计科目';


-- ----------------------------
-- Table structure for worker_node
-- ----------------------------
DROP TABLE IF EXISTS "public"."worker_node";
CREATE TABLE "public"."worker_node"
(
    "id"          serial8 PRIMARY KEY NOT NULL,
    "host_name"   varchar             NOT NULL,
    "port"        varchar             NOT NULL,
    "type"        int4                NOT NULL,
    "launch_date" date                NOT NULL,
    "updated_at"  timestamp(3)        NOT NULL,
    "created_at"  timestamp(3)        NOT NULL
)
;

COMMENT
ON TABLE "public"."worker_node" IS ' ID生成器';


ALTER TABLE "public"."accounting_detail_record"
    ADD CONSTRAINT "uk_adr_outerorderid_servicecode_directionflag" UNIQUE ("outer_order_id", "direction_flag");
ALTER TABLE "public"."freeze_detail_record"
    ADD CONSTRAINT "uk_adr_outerorderid_type" UNIQUE ("outer_order_id", "type");




