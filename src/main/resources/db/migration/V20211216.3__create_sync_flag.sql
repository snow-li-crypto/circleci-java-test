DROP TABLE IF EXISTS "public"."sync_flag";
CREATE TABLE "public"."sync_flag"
(
    "id"          serial8 PRIMARY KEY                    NOT NULL,
    "type"        varchar COLLATE "pg_catalog"."default" NOT NULL,
    "last_record" varchar COLLATE "pg_catalog"."default" NOT NULL,
    "created_at"  timestamp(3)                           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  timestamp(3)                           NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."sync_flag" OWNER TO "postgres";
COMMENT
ON COLUMN "public"."sync_flag".type IS '0-account opening 1-transaction 2-freeze 3-data check';