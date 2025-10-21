walker init {
    has root: user;
    
    with entry {
    root = here ++> user();
        root.name = "Root User";
        root.email = "root@example.com";
        root.age = 0;
        root.created_at = std.time_now();
        std.log("User graph initialized");
    }
}
walker create_user {
    has name: str = "";
    has email: str = "";
    has age: int = 0;
    has new_user: user;
    has current_time: str = "";
    
    with entry {
        current_time = std.time_now();
    new_user = here ++> user();
        new_user.name = name;
        new_user.email = email;
        new_user.age = age;
        new_user.created_at = current_time;
        
        report {
            "success": true,
            "user": {
                "name": name,
                "email": email,
                "age": age,
                "created_at": current_time
            }
        };
    }
}

walker get_all_users {
    has user_list: list = [];
    has users: list = [];
    has user_count: int = 0;
    
    with entry {
    users = [-->];
        for u in users {
            user_list.append({
                "name": u.context.name,
                "email": u.context.email,
                "age": u.context.age,
                "created_at": u.context.created_at
            });
        }
        
        user_count = user_list.length;        
        report {
            "success": true,
            "users": user_list,
            "count": user_count
        };
    }
}