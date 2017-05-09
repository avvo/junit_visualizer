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

## How it works
JUnit Visualizer will inspect the bucket you provide, creating a "project" for each parent level directory.
For example, in a bucket called ```ci-logs``` you have:
```
  project-1/SUITE=my_suite_1/sub_directory/build_number_123/some/other/path/test.xml
  project-1/SUITE=my_suite_1/sub_directory/build_number_124/some/other/path/test.xml
  project-1/SUITE=my_suite_2/build_number_123/some/other/path/test.xml
  project-1/SUITE=my_suite_2/build_number_124/some/other/path/test.xml
  project-2/build_number_1/test.xml
```
This would create 2 projects, the first one with 2 suites, the second with a ```default``` suite.

## S3 setup

The directory structure should follow this pattern:
<Project Name>/(<Suite Name parent>/(Suite sub directory))/build_number_####/**/<filename>.xml


If the project has a suite, all of the build directories must be in a suite. If you don't have a suite, the build directories can be directly under the parent.
 
We recommend that you create a retention policy to delete the files after 30 days. This will help keep the pulling process as light as possible. Your data will still be available in the local db. 

[circle_dropper](https://github.com/avvo/circle_dropper) can help transfer your CircleCI files to S3

