# JUnit Visualizer

This project reads JUnit XML files from S3 and compiles that data to provide an interactive UI summarizing your test performance and stability.  This is useful for improving test run performance and for finding your transient/flaky tests.

CircleCI can provide JUnit files if you use [their gem](https://github.com/circleci/minitest-ci) in your rails projects.

## Setup

Create your DB:

```rake db:setup```

Provide these environment variables:

* AWS_BUCKET (where you want to read the JUnit files from)
* AWS_REGION (for the bucket above)
* S3_ACCESS_KEY_ID
* S3_SECRET_ACCESS_KEY

We use mysql and redis.  You may need to set related environment variables for those (they have defaults):

* REDIS_HOST
* REDIS_PORT
* DB_HOST
* DB_PORT
* DB_USER
* DB_PASS

For production you need to set SECRET_KEY_BASE

This project is available in a docker image: https://hub.docker.com/r/avvo/junit_visualizer/

