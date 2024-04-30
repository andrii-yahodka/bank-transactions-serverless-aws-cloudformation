require 'aws-sdk-s3'
require 'csv'


def lambda_handler(event:, context:)
  bucket = 'robot-dreams-lesson-3'
  key = 'simple_regression.csv'
  
  client = Aws::S3::Client.new(region: 'eu-central-1')
  object = client.get_object(bucket: bucket, key: key)
    
  csv = CSV.parse(object.body, headers: true)
  gpa_values = csv.values_at('GPA').flatten.map(&:to_f)
    
  gpa_avg_value = (gpa_values.sum / gpa_values.length).round(2)
    
  return gpa_avg_value
end
