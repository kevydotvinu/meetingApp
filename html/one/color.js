const now = document.getElementById("now");
function highlight() {
  const words = now.textContent.split(" ");
  now.innerHTML = "";
  words.forEach((word) => {
    const span = now.appendChild(document.createElement('span'));
    span.textContent = word + ' ';
    if (word === 'Vacant') document.body.style.backgroundColor ="#DDFFDD";
  });
};
now.addEventListener("blur", highlight);
highlight();
