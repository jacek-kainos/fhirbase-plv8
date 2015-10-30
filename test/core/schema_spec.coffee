plv8 = require('../../plpl/src/plv8')
schema = require('../../src/core/schema')
pg_meta = require('../../src/core/pg_meta')
assert = require('assert')

describe "CORE: schema", ()->
  it "drop Users storage", ()->
    schema.drop_storage(plv8, 'Users')
    assert.equal(pg_meta.table_exists(plv8, 'users'), false)

  it "create Users storage and history.users", ()->
    schema.create_storage(plv8, 'Users')
    assert.equal(pg_meta.table_exists(plv8, 'users'), true)
    assert.equal(pg_meta.table_exists(plv8, 'users_history'), true)

  it "change Users storage name", ()->
    desc = schema.describe_table(plv8, 'users')
    assert.equal(desc.name, 'users')

  it "drop Users storage", ()->
    schema.drop_storage(plv8, 'Users')
    assert.equal(pg_meta.table_exists(plv8, 'Users'), false)
    assert.equal(pg_meta.table_exists(plv8, 'users_history'), false)
