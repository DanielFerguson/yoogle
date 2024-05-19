-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS channels_id_seq;
CREATE SEQUENCE IF NOT EXISTS videos_id_seq;
CREATE SEQUENCE IF NOT EXISTS sentences_id_seq;
-- Table Definition
CREATE TABLE "public"."channels" (
    "id" int4 NOT NULL DEFAULT nextval('channels_id_seq'::regclass),
    "name" varchar NOT NULL,
    PRIMARY KEY ("id")
);
CREATE TABLE "public"."videos" (
    "id" int4 NOT NULL DEFAULT nextval('videos_id_seq'::regclass),
    "name" varchar,
    "source_url" varchar NOT NULL,
    "transcribed" bool NOT NULL DEFAULT false,
    "channel_id" int4 NOT NULL,
    CONSTRAINT "videos_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "public"."channels"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);
CREATE TABLE "public"."sentences" (
    "id" int4 NOT NULL DEFAULT nextval('sentences_id_seq'::regclass),
    "video_id" int4 NOT NULL,
    "sentence" text NOT NULL,
    "start_at" float4 NOT NULL,
    "end_at" float4 NOT NULL,
    CONSTRAINT "sentences_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "public"."videos"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);