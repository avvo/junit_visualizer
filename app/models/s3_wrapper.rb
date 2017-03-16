require 'aws-sdk'
require 'tempfile'

class S3Wrapper

  def s3_resource
    @s3_resource ||= Aws::S3::Resource.new
  end

  def download_from_s3(s3_filename)
    s3_client = Aws::S3::Client.new

    bucket.object(s3_filename)
    file = Tempfile.new(clean_filename(s3_filename))

    File.open(file.path, 'wb') do |file|
      s3_client.get_object({bucket: bucket_name, key: s3_filename}, target: file)
    end

    file.path
  end

  def file_list_from_project_and_build(project_name:, build_number:)
    file_list_from_project(project_name).select{ |file| file.include?("build_number_#{build_number}/") }
  end

  def file_list_from_project(project_name)
    @file_list_from_project ||= begin
      list = []

      bucket.objects(prefix: "#{project_name}").each do |object|
        list << object.key
      end

      list
    end
  end

  def build_number_list(project_name)
    build_number_list = []

    file_list_from_project(project_name).each do |full_path|
      build_number_list << parse_build_number(full_path)
    end

    build_number_list.compact.uniq.sort
  end

  def suite_name_list(project_name)
    suite_list = []

    file_list_from_project(project_name).each do |full_path|
      suite_list << parse_suite_name(project_name, full_path)
    end

    suite_list.compact.uniq.sort
  end

  def parse_suite_name(project_name, filepath)
    modified_filepath = filepath

    path_array = modified_filepath.split("build_number_")

    return nil if path_array.size == 1

    full_project = path_array[0]

    full_project.slice!(project_name)
    full_project.slice!('/')
    suite_name = full_project.chomp('/')

    suite_name
  end

  def parse_build_number(filepath)
    modified_filepath = filepath

    _, build_number_full_path = modified_filepath.split("build_number_")

    return nil if build_number_full_path.nil?

    build_number, _ = build_number_full_path.split('/')
    # puts "build number: #{build_number}"

    build_number.to_i
  end

  private

  def clean_filename(filename)
    filename.gsub(/\W/, "")
  end

  def bucket
    @bucket ||= s3_resource.bucket(bucket_name)
  end

  def bucket_name
    @bucket_name ||= Rails.application.config_for(:s3).fetch("bucket_name")
  end
end
