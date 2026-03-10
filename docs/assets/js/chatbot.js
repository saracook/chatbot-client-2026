const apiUrl = "https://ada-lovelace.stanford.edu/chatbot/api/v1/query/";
const proxyUrl = 'http://localhost:5050/'; // The URL of your proxy server
console.log('apiUrl', apiUrl);
const baseurl = "chatbot-client-2026"

//curl -X POST "https://ada-lovelace.stanford.edu/chatbot/api/v1/query/" -H "Content-Type: application/json" -d '{"query":"How do I submit a slurm job on sherlock?", "cluster":"sherlock"}' | jq

//curl -X POST -H "Content-Type: application/json" -d '{"user_query":"why?"}' http://sh03-13n01:8000/query/

var currentCluster = "sherlock";
var existing = [];
const sendMessage = async (message) => {
  addMessage(message, "end");
  addThinking();
  let sendData = {
    "query": message,
    "cluster": currentCluster
  }
  try {
    const response = await fetch(proxyUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(sendData)
    });
    if (!response.ok) {
      throw new Error(
        `Unable to Fetch Data, Please check URL
                or Network connectivity!!`
      );
    }
    const resData = await response.json();
    console.log('resData:', resData);
    console.log('resData.answer:', resData.answer);
    convertMarkdown(resData.answer, resData.cluster);
    currentCluster = resData.cluster;
  } catch (error) {
    console.error('Some Error Occured:', error);
    var errorMessage = "Something has gone wrong, please try again.";
    console.error('errorMessage:', errorMessage);
    convertMarkdown(errorMessage, currentCluster);
  }
}

const convertMarkdown = async (message, cluster) => {
  console.log("convertMarkdown ", message);
  const mdMessage = marked.parse(message);
  console.log('mdMessage', mdMessage);
  addMessage(mdMessage, "start", cluster);
}
const addMessage = (msg, direction, cluster) => {
  removeThinking();
  const messageHolder = document.getElementById("messageHolder");
  const message = document.createElement("div");
  const bgColorClass = direction !== "start" ? "bg-digital-red" : "bg-gray-100";
  const pfp = '<img class="pfp rounded-circle me-4" src="' + baseurl + '/assets/images/ada.png" alt="Ada" />'
  const icon = direction !== "start" ? "" : pfp;
  const colClass = direction !== "start" ? "flex-col" : "";
  const cornerClass = direction !== "start" ? "" : "rounded-5";
  const colorClass = direction !== "start" ? "text-white" : "text-dark";
  const clusterClass = cluster;
  var clusterString = "";
  if (cluster) {
    clusterString = `<div class="cluster-label ${clusterClass}"> ${cluster}</div>`
  }
  const flexClass = "items-" + direction;
  console.log('colorClass', colorClass);
  message.innerHTML = `
     <div class="d-flex m-5 ${colClass} ${flexClass}">
     ${icon}
     <div class="${bgColorClass} ${colorClass} ${cornerClass}  flex-grow-1 p-4 rounded-5 border border-dark-subtle">${msg}
     </div>         
    `
  messageHolder.appendChild(message);
  scrollDown();

}

const scrollDown = function(){
  const messageHolder = document.getElementById("messageHolder");
           messageHolder.scrollIntoView({
                block: 'end',
                behavior: 'smooth',
                inline: 'nearest'
            });
             console.log('scrolling message');
            document.getElementById("chat").focus();
}


const addThinking = () => {
  console.log('adding thinking');
  var message = document.createElement("div");
  message.id = 'thinking';
  const messageText = '<i class="fa-solid fa-asterisk fa-spin me-2 ms-5 digital-red"></i> Ada is thinking...';
  const messageHolder = document.getElementById("messageHolder");
    message.innerHTML = `
<div class="d-flex">
     <img class="pfp rounded-circle" src="/assets/images/ada.png" alt="Ada">
     <div class=" flex-grow-1">
     ${messageText}
     </div>         
    </div>    
    `
  messageHolder.appendChild(message);
  scrollDown();
}

const removeThinking = () => {
  console.log('removing thinking');
  const thinking = document.getElementById("thinking");
  if (thinking) {
    thinking.remove();
  }
    scrollDown();
}

const messageInput = document.getElementById("chat");
const sendBtn = document.getElementById("btn");
console.log('messageInput', messageInput);

messageInput.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    //console.log('submitting', event);
    const message = messageInput.value;
    sendMessage(message);
    console.log('message input enter', message);
    messageInput.value = "";
  }
});



const myModalEl = document.getElementById('chatModal');
myModalEl.addEventListener('shown.bs.modal', function (event) {
  document.getElementById("chat").focus();
});

sendBtn.addEventListener("click", function() {
  const message = messageInput.value;
  console.log('message input send', message);
  sendMessage(message);
  messageInput.value = "";
});

const helloMessage = "Hi! I'm Ada. I can help you learn how to use Stanford's HPC resources."
addMessage(helloMessage, "start");
