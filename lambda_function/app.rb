require 'aws-sdk-s3'
require 'aws-sdk-dynamodb'
require 'random/formatter'

class Transaction
  def self.build
    {
      user_id:    SecureRandom.hex,
      project_id: SecureRandom.hex,
      amount:     Random.new.random_number(1000),
      currency:   ['UAH', 'EUR', 'USD'].sample,
      type:       ['monthly', 'yearly'].sample
    }
  end
end

class DynamoDb
  def initialize(item)
    @client     = Aws::DynamoDB::Client.new(region: 'eu-central-1')
    @table_name = 'TransactionsTable'
    @item       = item
  end
  
  def put_item
    @client.put_item(table_name: @table_name, item: @item)
  end
end

class S3
  def initialize(item)
    @client = Aws::S3::Client.new(region: 'eu-central-1')
    @bucket = 'bank-transaction-invoices-andrii-yahodka'
    @key    = "#{item[:user_id]}_#{item[:type]}_invoice_#{item[:project_id]}.txt"
  end
  
  def put_object
    @client.put_object(bucket: @bucket, key: @key)
  end
end


def lambda_handler(event:, context:)
  item = Transaction.build
  
  DynamoDb.new(item).put_item
  S3.new(item).put_object
    
  return {
    statusCode: 200,
    body: item.to_json
  }
end
