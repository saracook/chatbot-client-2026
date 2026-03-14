// Clean version with improvements:

const apiUrl = "https://ada-lovelace.stanford.edu/chatbot/api/v1/query/";
const baseurl = "";
let currentCluster = "sherlock";

const sendMessage = async (message) => {
  if (!message.trim()) return; // Don't send empty messages
  
  addMessage(message, "end");
  addThinking();
  
  const sendData = {
    query: message,
    cluster: currentCluster
  };
  
  try {
    const response = await fetch(apiUrl, {
      method: 'POST',
      credentials: 'include', // if auth needed
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(sendData)
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const resData = await response.json();
    console.log('Response:', resData);
    
    await convertMarkdown(resData.answer, resData.cluster);
    currentCluster = resData.cluster;
    
  } catch (error) {
    console.error('Error occurred:', error);
    const errorMessage = `Sorry, something went wrong: ${error.message}. Please try again.`;
    await convertMarkdown(errorMessage, currentCluster);
  }
};

const convertMarkdown = async (message, cluster) => {
  const mdMessage = marked.parse(message);
  addMessage(mdMessage, "start", cluster);
};

const addMessage = (msg, direction, cluster = null) => {
  removeThinking();
  
  const messageHolder = document.getElementById("messageHolder");
  const message = document.createElement("div");
  
  const isUser = direction !== "start";
  const bgColorClass = isUser ? "bg-digital-red" : "bg-gray-100";
  const colorClass = isUser ? "text-white" : "text-dark";
  const cornerClass = isUser ? "" : "rounded-5";
  const colClass = isUser ? "flex-col" : "";
  const flexClass = `items-${direction}`;
  
  const pfp = `<img class="pfp rounded-circle me-4" src="${baseurl}/assets/images/ada.png" alt="Ada" />`;
  const icon = isUser ? "" : pfp;
  
  const clusterLabel = cluster 
    ? `<div class="cluster-label ${cluster}">${cluster}</div>` 
    : "";
  
  message.innerHTML = `
    <div class="d-flex m-5 ${colClass} ${flexClass}">
      ${icon}
      <div class="${bgColorClass} ${colorClass} ${cornerClass} flex-grow-1 p-4 rounded-5 border border-dark-subtle">
        ${msg}
        ${clusterLabel}
      </div>         
    </div>`;
  
  messageHolder.appendChild(message);
  scrollDown();
};

const scrollDown = () => {
  const messageHolder = document.getElementById("messageHolder");
  messageHolder.scrollIntoView({
    block: 'end',
    behavior: 'smooth',
    inline: 'nearest'
  });
  document.getElementById("chat")?.focus();
};

const addThinking = () => {
  const message = document.createElement("div");
  message.id = 'thinking';
  
  const messageHolder = document.getElementById("messageHolder");
  message.innerHTML = `
    <div class="d-flex">
      <img class="pfp rounded-circle" src="${baseurl}/assets/images/ada.png" alt="Ada">
      <div class="flex-grow-1">
        <i class="fa-solid fa-asterisk fa-spin me-2 ms-5 digital-red"></i> Ada is thinking...
      </div>         
    </div>`;
  
  messageHolder.appendChild(message);
  scrollDown();
};

const removeThinking = () => {
  document.getElementById("thinking")?.remove();
  scrollDown();
};

// Event Listeners
const messageInput = document.getElementById("chat");
const sendBtn = document.getElementById("btn");

const handleSend = () => {
  const message = messageInput.value;
  if (message.trim()) {
    sendMessage(message);
    messageInput.value = "";
  }
};

messageInput?.addEventListener("keypress", (event) => {
  if (event.key === "Enter") {
    event.preventDefault();
    handleSend();
  }
});

sendBtn?.addEventListener("click", handleSend);

const myModalEl = document.getElementById('chatModal');
myModalEl?.addEventListener('shown.bs.modal', () => {
  document.getElementById("chat")?.focus();
});

// Initial greeting
const helloMessage = "Hi! I'm Ada. I can help you learn how to use Stanford's HPC resources.";
addMessage(helloMessage, "start");
