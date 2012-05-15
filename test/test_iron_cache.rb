gem 'test-unit'
require 'test/unit'
require 'yaml'
require_relative 'test_base'

class IronCacheTests < TestBase
  def setup
    super

  end

  def test_basics
    @client.cache_name = 'test_basics'
    clear_queue

    k = "key1"
    v = "hello world!"
    res = @client.items.put(k, v)
    # another naming option we could try:
    #res = @client.cache('test_basics').items.put("key1", "hello world!")
    p res
    assert res.msg

    res = @client.items.get(k)
    p res
    assert res["key"]
    assert res.key
    assert res.key == k
    assert res.value == v

    res = @client.items.delete(res.key)
    p res
    puts "shouldn't be any more"
    res = @client.items.get(k)
    p res
    assert res.nil?

  end

  def test_caches
    caches = @client.caches.list
    p caches
    assert caches
    assert caches.is_a?(Array)
    assert caches.size > 0
    assert caches[0].name

  end

  def test_expiry
    @client.cache_name = 'test_basics'
    clear_queue
    k = "key1"
    v = "hello world!"
    res = @client.items.put(k, v, :expires_in=>10)

    res = @client.items.get(k)
    p res
    assert res.key == k

    sleep 11
    res = @client.items.get(k)
    assert res.nil?, "res is not nil, should be nil because it expired, but it's: #{res}"

  end

end

