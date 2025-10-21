walker analyze_users {
    has total_users: int = 0;
    has total_age = 0;
    has email_list = [];
    has avg_age = 0.0;
    has domains = {};
    has domain = "";
    has parts = [];
    
    with entry {
        for user in --> node::user {
            total_users += 1;
            total_age += user.context["age"];
            email_list.l::append(user.context["email"]);
        }
        
        if (total_users > 0) {
            avg_age = total_age / total_users;
        }
        
        for email in email_list {
            parts = email.split('@');
            if (parts.length > 1) {
                domain = parts[1];
                if (domain in domains) {
                    domains[domain] += 1;
                } else {
                    domains[domain] = 1;
                }
            }
        }
        
        report {
            "success": true,
            "analysis": {
                "total_users": total_users,
                "average_age": avg_age,
                "email_domains": domains
            }
        };
    }
}

# Custom ability for email domain analysis
can analyze_email_domains with emails entry {
    has domains = {};
    has domain = "";
    has parts = [];
    
    for email in emails {
        parts = email.split('@');
        if (parts.length > 1) {
            domain = parts[1];
            if (domain in domains) {
                domains[domain] += 1;
            } else {
                domains[domain] = 1;
            }
        }
    }
    return domains;
}