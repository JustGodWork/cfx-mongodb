local function printFiveUsers()

    Mongo.find('users', nil, {
        projection = {username = 1, _id = 0} -- Include username and exclude _id field
    }, 5, function(success, result)

        if (not success) then return; end

        print("\n** 5 users");

        for i, document in ipairs(result) do
            for k, v in pairs(document) do
                print("* "..tostring(k).." = \""..tostring(v).."\"")
            end
        end

    end);

end

local function printUser(id)
    Mongo.findOne("users", { _id = id }, nil, function(success, result)

        if (not success) then return; end

        print("\n** User document")
        for k, v in pairs(result[1]) do
            print("* "..tostring(k).." = \""..tostring(v).."\"")
        end

    end);
end

Mongo.ready(function(databaseName)

    print("[MongoDB][Example] Database connected: "..tostring(databaseName));

    local username = "User0";

    -- Find user by username
    Mongo.findOne("users", { username = username }, nil, function(success, result)

        if (not success) then
            print("[MongoDB][Example] Error in findOne: "..tostring(result));
            return;
        end


        -- Print user if already exists
        if (#result > 0) then

            print("[MongoDB][Example] User is already created");
            printUser(result[1]._id);
            Mongo.updateOne("users", { _id = result[1]._id }, { ["$set"] = { first_name = "Bob" } });
            return;

        end

        print("[MongoDB][Example] User does not exist. Creating...");

        Mongo.insertOne("users", { username = username, password = "123" }, nil, function(success, result, insertedIds)

            if (not success) then
                print("[MongoDB][Example] Error in insertOne: "..tostring(result))
                return
            end

            print("[MongoDB][Example] User created. New ID: "..tostring(insertedIds[1]));
            printUser(insertedIds[1]);

        end);

    end);

    Mongo.count('users', nil, nil, function(success, result)

        if (not success) then
            print("[MongoDB][Example] Error in count: "..tostring(result));
            return;
        end

        print("[MongoDB][Example] Current users count: "..tostring(result));

        if (result < 10) then

            local insertUsers = {};

            for i = 1, 10 do
                table.insert(insertUsers, { username = "User"..i, password = "123456" });
            end

            Mongo.insert("users", insertUsers, nil, function(success, result)

                if (not success) then
                    print("[MongoDB][Example] Failed to insert users: "..tostring(result));
                    return;
                end

                print("[MongoDB][Example] Inserted "..tostring(result).." new users");

                printFiveUsers();

            end);
        else
            printFiveUsers();
        end

    end);

end);
