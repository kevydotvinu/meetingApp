const color = document.getElementById("color");
function highlight() {
  const words = color.textContent.split(" ");
  color.innerHTML = "";
  words.forEach((word) => {
    const span = color.appendChild(document.createElement('span'));
    span.textContent = word + ' ';
    if (word === 'Vacant') span.classList.add('green');
    if (word === 'bad') span.classList.add('red');
  });
};
color.addEventListener("blur", highlight);
highlight();
