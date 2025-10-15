const BASE_URL = "http://localhost:8000/js/walker_run/api_generate_poem";

async function generatePoem() {
  const topic = document.getElementById("topic").value || "nature";

  document.getElementById("output").innerHTML = "<em>Generating...</em>";

  try {
    const res = await fetch(BASE_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ topic }),
    });

    const data = await res.json();
    document.getElementById("output").innerHTML = `<h3>${data.topic}</h3><pre>${data.poem}</pre>`;
  } catch (err) {
    document.getElementById("output").textContent = "Error contacting Jac server.";
    console.error(err);
  }
}

