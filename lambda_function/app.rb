require 'aws-sdk-s3'
require 'aws-sdk-dynamodb'
require 'random/formatter'

class Item
  def self.build
    {
      id: SecureRandom.hex,
      first_name: "First name - #{Random.new.alphanumeric(5)}",
      last_name: "Last name - #{Random.new.alphanumeric(5)}",
      position: "Position - #{Random.new.alphanumeric(5)}",
      salary: Random.new.random_number(1000)
    }
  end
end

class DynamoDb
  def initialize(item)
    @client     = Aws::DynamoDB::Client.new(region: 'eu-central-1')
    @table_name = 'ClientsTable'
    @item       = item
  end
  
  def put_item
    @client.put_item(table_name: 'ClientsTable', item: @item)
  end
end

class S3
  def initialize(item)
    @client = Aws::S3::Client.new(region: 'eu-central-1')
    @bucket = 'robot-dreams-lesson-3'
    @key    = "#{item[:id]}_credentials.txt"
  end
  
  def put_object
    @client.put_object(bucket: @bucket, key: @key)
  end
end


def lambda_handler(event:, context:)
  item = Item.build
  
  DynamoDb.new(item).put_item
  S3.new(item).put_object
    
  return {
    statusCode: 200,
    body: item.to_json
  }
end
