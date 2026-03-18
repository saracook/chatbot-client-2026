const apiUrl = "https://ada-lovelace.stanford.edu:8080/chatbot/api/v1/query/";
// const apiUrl = "http://localhost:7000/chatbot/api/v1/query"
console.log('apiUrl', apiUrl);

var currentCluster = "sherlock";
var existing = [];

// ===== BUTTON COLLAPSE FUNCTIONALITY =====
document.addEventListener('DOMContentLoaded', function() {
  const chatContainer = document.getElementById('chatButtonContainer');
  const chatButton = document.getElementById('chatModalButton');
  const chatModal = document.getElementById('chatModal');
  const dismissButton = document.getElementById('dismissButton');
  const chatIcon = document.getElementById('chatIcon');
  
  // Check if user previously dismissed the bubble
  if (localStorage.getItem('adaBubbleDismissed') === 'true') {
    chatContainer.classList.add('collapsed');
    chatIcon.classList.remove('d-none');
    chatIcon.classList.add('d-block');
  }
  
  // Dismiss button - collapse to edge
  dismissButton.addEventListener('click', function(e) {
    e.stopPropagation(); // Prevent modal from opening
    e.preventDefault();
    chatContainer.classList.add('collapsed');
    chatIcon.classList.remove('d-none');
    chatIcon.classList.add('d-block');
    localStorage.setItem('adaBubbleDismissed', 'true');
  });

  // When modal is closed, collapse the button
  chatModal.addEventListener('hidden.bs.modal', function() {
    chatContainer.classList.add('collapsed');
    chatIcon.classList.remove('d-none');
    chatIcon.classList.add('d-block');
    localStorage.setItem('adaBubbleDismissed', 'true');
  });
  
});
// ===== MESSAGE HANDLING =====
const sendMessage = async (message) => {
  // Validate input
  if (!message || message.trim() === '') {
    console.log('Empty message, not sending');
    return;
  }
  
  addMessage(message, "end");
  addThinking();
  
  let sendData = {
    "query": message,
    "cluster": currentCluster
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
      throw new Error(
        `HTTP error! status: ${response.status}`
      );
    }
    
    
    const resData = await response.json();
    console.log('Response:', resData);
    
    await convertMarkdown(resData.answer, resData.cluster);
    currentCluster = resData.cluster;
    
  } catch (error) {
    console.error('Error occurred:', error);
    var errorMessage = "Something went wrong. Please try again or contact support if the issue persists.";
    convertMarkdown(errorMessage, currentCluster);
  }
};

const convertMarkdown = async (message, cluster) => {
  const mdMessage = marked.parse(message);
  addMessage(mdMessage, "start", cluster);
};

const addMessage = (msg, direction, cluster) => {
  removeThinking();
  
  const messageHolder = document.getElementById("messageHolder");
  const message = document.createElement("div");
  const bgColorClass = direction !== "start" ? "bg-digital-red" : "bg-gray-100";
  const pfp = '<img class="pfp rounded-circle me-4" src="/assets/images/ada.png" alt="Ada" />';
  const icon = direction !== "start" ? "" : pfp;
  const colClass = direction !== "start" ? "flex-col" : "";
  const cornerClass = direction !== "start" ? "" : "rounded-5";
  const colorClass = direction !== "start" ? "text-white" : "text-dark";
  const clusterClass = cluster;
  var clusterString = "";
  
  if (cluster) {
    clusterString = `<div class="cluster-label ${clusterClass}"> ${cluster}</div>`;
  }
  
  const flexClass = "items-" + direction;
  console.log('colorClass', colorClass);
  
  message.innerHTML = `
    <div class="d-flex m-5 ${colClass} ${flexClass}">
      ${icon}
      <div class="${bgColorClass} ${colorClass} ${cornerClass} flex-grow-1 p-4 rounded-5 border border-dark-subtle">
        ${msg}
      </div>         
    </div>
  `;
  
  messageHolder.appendChild(message);
  scrollDown();
};


const scrollDown = function() {
  const messageHolder = document.getElementById("messageHolder");
  messageHolder.scrollIntoView({
    block: 'end',
    behavior: 'smooth',
    inline: 'nearest'
  });
  console.log('scrolling message');
  document.getElementById("chat").focus();
};

const addThinking = () => {
  const message = document.createElement("div");
  message.id = 'thinking';
  
  const messageHolder = document.getElementById("messageHolder");
  
  message.innerHTML = `
    <div class="d-flex">
      <img class="pfp rounded-circle" src="/assets/images/ada.png" alt="Ada">
      <div class="flex-grow-1">
        <span class="thinking-dots">...</span>
      </div>
    </div>    
  `;
  
  messageHolder.appendChild(message);
  scrollDown();
};


const removeThinking = () => {
  console.log('removing thinking');
  const thinking = document.getElementById("thinking");
  if (thinking) {
    thinking.remove();
  }
  scrollDown();
};

// ===== EVENT LISTENERS =====
const messageInput = document.getElementById("chat");
const sendBtn = document.getElementById("btn");

messageInput.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    event.preventDefault(); // Prevent form submission if inside a form
    const message = messageInput.value;
    sendMessage(message);
    messageInput.value = "";
  }
});


const myModalEl = document.getElementById('chatModal');
myModalEl.addEventListener('shown.bs.modal', function (event) {
  document.getElementById("chat").focus();
  // Optional: Clear thinking indicator if modal reopens while waiting
  removeThinking();
});

// Optional: Clear chat when modal is hidden
// myModalEl.addEventListener('hidden.bs.modal', function (event) {
//   document.getElementById("messageHolder").innerHTML = "";
//   addMessage(helloMessage, "start");
// });

sendBtn.addEventListener("click", function() {
  const message = messageInput.value;
  console.log('message input send', message);
  sendMessage(message);
  messageInput.value = "";
});

// ===== INITIALIZATION =====
const helloMessage = "Hi! I'm Ada. I can help you learn how to use Stanford's HPC resources.";
addMessage(helloMessage, "start");
