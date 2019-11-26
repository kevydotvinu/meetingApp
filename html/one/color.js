const now = document.getElementById("now");
const upcoming = document.getElementById("upcoming");
function highlight() {
  const words = now.textContent.split(" ");
  now.innerHTML = "";
  words.forEach((word) => {
    const span = now.appendChild(document.createElement('span'));
    span.textContent = word + ' ';
    if (word === 'Vacant') span.classList.add('green');
  const words = upcoming.textContent.split(" ");
  upcoming.innerHTML = "";
  words.forEach((word) => {
    const span = upcoming.appendChild(document.createElement('span'));
    span.textContent = word + ' ';
    if (word === 'Vacant') span.classList.add('green');
});
};
color.addEventListener("blur", highlight);
highlight();
