BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "activity_rsvp" (
    "id" bigserial PRIMARY KEY,
    "activityId" bigint NOT NULL,
    "userIdentifier" text,
    "joinedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "activity_rsvp_activity_user_unique_idx" ON "activity_rsvp" USING btree ("activityId", "userIdentifier");
CREATE INDEX "activity_rsvp_user_joined_idx" ON "activity_rsvp" USING btree ("userIdentifier", "joinedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "campus_activity" (
    "id" bigserial PRIMARY KEY,
    "kind" text NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "topic" text,
    "startsAt" timestamp without time zone NOT NULL,
    "endsAt" timestamp without time zone,
    "location" text NOT NULL,
    "capacity" bigint,
    "organizerName" text NOT NULL,
    "createdByUserIdentifier" text,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" text NOT NULL DEFAULT 'active'::text,
    "isDemo" boolean NOT NULL DEFAULT false
);

-- Indexes
CREATE INDEX "campus_activity_status_start_idx" ON "campus_activity" USING btree ("status", "startsAt");
CREATE INDEX "campus_activity_owner_start_idx" ON "campus_activity" USING btree ("createdByUserIdentifier", "startsAt");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "activity_rsvp"
    ADD CONSTRAINT "activity_rsvp_fk_0"
    FOREIGN KEY("activityId")
    REFERENCES "campus_activity"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR campus_loop
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('campus_loop', '20261025185542138-campus-activities', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261025185542138-campus-activities', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
