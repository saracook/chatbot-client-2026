// New code - works with the proxy
const proxyUrl = 'http://localhost:5050/'; // The URL of your proxy server

async function queryChatbot(payload) {
  try {
    const response = await fetch(proxyUrl, { // <--- The ONLY change is here
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        // If you use an auth token, it will be forwarded automatically by the proxy
        // 'Authorization': 'Bearer YOUR_TOKEN' 
      },
      body: JSON.stringify(payload)
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`API Error (${response.status}): ${errorText}`);
    }

    return response.json();
  } catch (error) {
    console.error("Failed to fetch through proxy:", error);
    throw error;
  }
}

// Example usage:
queryChatbot({ "query":"How do I submit a slurm job on sherlock?", "cluster":"sherlock" })
  .then(data => {
    console.log("Success:", data);
  })
  .catch(error => {
    console.error("Error:", error);
  });
