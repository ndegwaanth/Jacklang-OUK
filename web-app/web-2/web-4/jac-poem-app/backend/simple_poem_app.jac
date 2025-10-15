# Simple version for testing - no external API dependencies
walker api_generate_poem {
    has input topic = "nature";
    has output poem;
    has output status = "success";

    with entry {
        if topic.strip() == "" {
            topic = "nature";
        }

        # Simple poem generation without external API
        poems = {
            "nature": """
In forests deep where sunlight streams,
Where nature weaves her endless dreams,
The rivers flow, the mountains stand,
A perfect work by nature's hand.

The birds they sing their morning song,
To this great world we all belong,
In every leaf and every stone,
A beauty that we've always known.
""",
            "love": """
Your love is like a gentle breeze,
That whispers softly through the trees,
It warms my heart and makes me see,
How beautiful our life can be.

In your embrace I find my home,
No more through life I'll ever roam,
Your loving touch, your caring way,
Brightens up my every day.
""",
            "technology": """
In circuits deep and silicon dreams,
Where digital light in rivers streams,
Technology grows with mighty power,
Changing our world hour by hour.

From simple code to AI's mind,
New possibilities we find,
The future's here, both bold and bright,
Guided by technology's light.
"""
        };

        # Get poem or generate default
        if poems.get(topic.lower()) {
            poem = poems[topic.lower()];
        } else {
            poem = f"""
A poem about {topic} so fine,
With words that rhythm and rhyme,
Created just for you this time,
A little piece of the sublime.

The {topic} inspires my verse,
Making the universe diverse,
A subject that I can't rehearse,
But put in this poetic universe.
""";
        }

        report {
            "topic": topic,
            "poem": poem,
            "status": status
        };
    }
}

walker api_status {
    with entry {
        report {
            "status": "ready",
            "message": "Jac AI Poem Generator Server is running",
            "timestamp": std.time_now()
        };
    }
}

with entry {
    print("✅ Simple Jac Poem Generator Server ready!");
    print("📝 Using built-in poem examples for testing");
}