const apiUrl = "https://ada-lovelace.stanford.edu/chatbot/api/v1/query/";
console.log('apiUrl', apiUrl);

var currentCluster = document.getElementById('clusterSelect')?.value || "sherlock";

document.getElementById('clusterSelect')?.addEventListener('change', function() {
  currentCluster = this.value;
});

// ===== BUTTON COLLAPSE FUNCTIONALITY =====
document.addEventListener('DOMContentLoaded', function() {
  const chatContainer = document.getElementById('chatButtonContainer');
  const chatButton = document.getElementById('chatModalButton');
  const chatModal = document.getElementById('chatModal');
  const dismissButton = document.getElementById('dismissButton');
  const chatIcon = document.getElementById('chatIcon');
  const chatText = document.getElementById('chatText');

  if (localStorage.getItem('adaBubbleDismissed') === 'true') {
    chatContainer.classList.add('collapsed');
    chatIcon?.classList.replace('d-none', 'd-inline-block');
    chatText?.classList.add('d-none');
  }

  const collapseButton = () => {
    chatContainer.classList.add('collapsed');
    chatIcon?.classList.replace('d-none', 'd-inline-block');
    chatText?.classList.add('d-none');
    localStorage.setItem('adaBubbleDismissed', 'true');
  };

  dismissButton.addEventListener('click', (e) => { e.stopPropagation(); e.preventDefault(); collapseButton(); });
  chatModal.addEventListener('hidden.bs.modal', collapseButton);
});

// ===== RESPONSE PARSING =====

/**
 * Detects the default "could not find" fallback response.
 */
function isFallbackResponse(answer) {
  return answer.toLowerCase().includes("i could not find the information");
}

/**
 * Parses a raw API response into a normalized structure.
 * @param {Object} response
 * @returns {{ cluster: string|null, isOutOfScope: boolean, isFallback: boolean, html: string, sources: Array<{title,url}> }}
 */
function parseApiResponse(response) {
  const { answer = "", cluster = null, sources = [] } = response;

  const isOutOfScope = answer.toLowerCase().includes("i can only help with");
  const fallback = isFallbackResponse(answer);

  // Strip the inline "**Sources:**" block from the markdown before rendering,
  // since we render sources separately from the structured `sources` array.
  const answerWithoutSources = answer
    .replace(/\*\*Sources:\*\*[\s\S]*$/m, "")
    .trimEnd();

  const html = marked.parse(answerWithoutSources);

  const validSources = sources.filter(
    s => s && typeof s.title === "string" && typeof s.url === "string"
  );

  return { cluster, isOutOfScope, isFallback: fallback, html, sources: validSources };
}

/**
 * Builds an HTML string for the sources footer, or empty string if none.
 */
function buildSourcesHtml(sources) {
  if (!sources.length) return "";
  const links = sources
    .map(({ title, url }) => `<li><a href="${url}" target="_blank" rel="noopener noreferrer">${title}</a></li>`)
    .join("");
  return `<div class="sources-block mt-3 pt-2 border-top border-dark-subtle">
    <p class="fw-semibold mb-1 small">Sources</p>
    <ul class="list-unstyled mb-0 small">${links}</ul>
  </div>`;
}

// ===== MESSAGE HANDLING =====
const sendMessage = async (message) => {
  if (!message || message.trim() === '') return;

  addMessage(message, "end");
  addThinking();

  try {
    const response = await fetch(apiUrl, {
      method: 'POST',
      credentials: 'include',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query: message, cluster: currentCluster })
    });

    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);

    const resData = await response.json();
    console.log('Response:', resData);

    const parsed = parseApiResponse(resData);
    const fullHtml = parsed.html + buildSourcesHtml(parsed.sources);
    addMessage(fullHtml, "start", parsed.cluster, parsed.isFallback, parsed.isOutOfScope);

  } catch (error) {
    console.error('Error occurred:', error);
    addMessage(
      "<p>Something went wrong. Please try again or contact support if the issue persists.</p>",
      "start",
      currentCluster
    );
  }
};

const addMessage = (msg, direction, cluster, isFallback = false, isOutOfScope = false) => {
  removeThinking();

  const messageHolder = document.getElementById("messageHolder");
  const message = document.createElement("div");
  const bgColorClass = direction !== "start" ? "bg-digital-red" : "bg-gray-100";
  const pfp = '<img class="pfp rounded-circle me-4" src="/assets/images/ada.png" alt="Ada" />';
  const icon = direction !== "start" ? "" : pfp;
  const colClass = direction !== "start" ? "flex-col" : "";
  const cornerClass = direction !== "start" ? "" : "rounded-5";
  const colorClass = direction !== "start" ? "text-white" : "text-dark";
  const flexClass = "items-" + direction;

  const fallbackIcon = isFallback
    ? `<i class="fa-solid fa-envelope me-2 text-warning"></i>`
    : isOutOfScope
    ? `<i class="fa-solid fa-circle-question me-2 text-warning"></i>`
    : "";

  message.innerHTML = `
    <div class="d-flex m-5 ${colClass} ${flexClass}">
      ${icon}
      <div class="${bgColorClass} ${colorClass} ${cornerClass} flex-grow-1 p-4 rounded-5 border ${isFallback || isOutOfScope ? "border-warning" : "border-dark-subtle"}">
        ${fallbackIcon}${msg}
      </div>
    </div>
  `;

  messageHolder.appendChild(message);
  scrollDown();
};

const scrollDown = () => {
  document.getElementById("messageHolder").scrollIntoView({
    block: 'end', behavior: 'smooth', inline: 'nearest'
  });
  document.getElementById("chat").focus();
};

const addThinking = () => {
  const message = document.createElement("div");
  message.id = 'thinking';
  message.innerHTML = `
    <div class="d-flex m-5">
      <img class="pfp rounded-circle me-4" src="/assets/images/ada.png" alt="Ada">
      <div class="flex-grow-1">
        <i class="fa-solid fa-asterisk fa-spin me-2 digital-red"></i> Ada is thinking...
      </div>
    </div>
  `;
  document.getElementById("messageHolder").appendChild(message);
  scrollDown();
};

const removeThinking = () => {
  document.getElementById("thinking")?.remove();
  scrollDown();
};

// ===== EVENT LISTENERS =====
const messageInput = document.getElementById("chat");
const sendBtn = document.getElementById("btn");

messageInput.addEventListener("keypress", function(event) {
  if (event.key === "Enter") {
    event.preventDefault();
    sendMessage(messageInput.value);
    messageInput.value = "";
  }
});

sendBtn.addEventListener("click", function() {
  sendMessage(messageInput.value);
  messageInput.value = "";
});

document.getElementById('chatModal').addEventListener('shown.bs.modal', function() {
  document.getElementById("chat").focus();
  removeThinking();
});

// ===== INITIALIZATION =====
addMessage("Hi! I'm Ada. I can help you learn how to use Stanford's HPC resources.", "start");
