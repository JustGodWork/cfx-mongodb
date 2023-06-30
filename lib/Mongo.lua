---@class Mongo
Mongo = {};
local db_name = GetConvar("mongodb_database", "changeme");

if (not exports.mongodb or not GetResourceState('mongodb'):find('start')) then
    error("MongoDB resource is not running. Please start it before using this resource.");
    os.exit();
end

---@param data table
local function validate_data(data)
    return type(data) == "table" and data or {};
end

---@param callback fun(database: string)
---@return table
function Mongo.ready(callback)

    local is_connected = Mongo.isConnected();

    if (type(callback) == 'function') then

        if (not is_connected) then

            local ready;
            ready = AddEventHandler('onDatabaseConnect', function(db_name)

                callback(db_name);
                RemoveEventHandler(ready);

            end);

            return;

        end

        callback(db_name);
        return;

    end

    print('^7(^5SERVER^7) => ^7(^1ERROR^7)=>^0 ^7(^6MongoDB^7)^0 => Mongo.ready: callback is not a function.');

end

---Checks if the MongoDB connection is active.
---@return boolean
function Mongo.isConnected()
    return exports.mongodb:isConnected();
end

---@param collection string
---@param documents table
---@param options table
---@param callback fun(success: boolean, insertedCount: number, insertedIds: table)
---@overload fun(collection: string, documents: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.insert(collection, documents, options, callback)
    return exports.mongodb:insert({
        collection = collection,
        documents = validate_data(documents) or {},
        options = validate_data(options)
    }, callback);
end

---@param collection string
---@param document table
---@param options table
---@param callback fun(success: boolean, insertedCount: number, insertedIds: table)
---@overload fun(collection: string, document: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.insertOne(collection, document, options, callback)
    return exports.mongodb:insertOne({
        collection = collection,
        document = validate_data(document) or {},
        options = validate_data(options)
    }, callback);
end

---@param collection string
---@param query table
---@param options table
---@param limit number
---@param callback fun(success: boolean, documents: table)
---@overload fun(collection: string, query: table, options: table, limit: number, callback: fun(success: boolean, error: string))
function Mongo.find(collection, query, options, limit, callback)
    return exports.mongodb:find({
        collection = collection,
        query = validate_data(query) or {},
        options = validate_data(options),
        limit = limit
    }, callback);
end

---@param collection string
---@param query table
---@param options table
---@param callback fun(success: boolean, document: table)
---@overload fun(collection: string, query: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.findOne(collection, query, options, callback)
    return exports.mongodb:findOne({
        collection = collection,
        query = validate_data(query) or {},
        options = validate_data(options)
    }, callback);
end

---@param collection string
---@param query table
---@param options table
---@param callback fun(success: boolean, deletedCount: number)
---@overload fun(collection: string, query: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.delete(collection, query, options, callback)
    return exports.mongodb:delete({
        collection = collection,
        query = validate_data(query) or {},
        options = validate_data(options)
    }, callback);
end

---@param collection string
---@param query table
---@param options table
---@param callback fun(success: boolean, deletedCount: number)
---@overload fun(collection: string, query: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.deleteOne(collection, query, options, callback)
    return exports.mongodb:deleteOne({
        collection = collection,
        query = validate_data(query) or {},
        options = validate_data(options)
    }, callback);
end

---@param collection string
---@param query table
---@param update table
---@param options table
---@param callback fun(success: boolean, updatedCount: number)
---@overload fun(collection: string, query: table, update: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.update(collection, query, update, options, callback)
    return exports.mongodb:update({
        collection = collection,
        query = validate_data(query) or {},
        update = validate_data(update) or {},
        options = validate_data(options)
    }, callback);
end

---@param collection string
---@param query table
---@param update table
---@param options table
---@param callback fun(success: boolean, updatedCount: number)
---@overload fun(collection: string, query: table, update: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.updateOne(collection, query, update, options, callback)
    return exports.mongodb:updateOne({
        collection = collection,
        query = validate_data(query) or {},
        update = validate_data(update) or {},
        options = validate_data(options)
    }, callback);
end

---@param collection string
---@param query table
---@param options table
---@param callback fun(success: boolean, count: number)
---@overload fun(collection: string, query: table, options: table, callback: fun(success: boolean, error: string))
function Mongo.count(collection, query, options, callback)
    return exports.mongodb:count({
        collection = collection,
        query = validate_data(query) or {},
        options = validate_data(options)
    }, callback);
end