window.onload = () => {
    const toggleSwitch = document.getElementById("switch");
    const toggleSwitchText = toggleSwitch.querySelector("p");
    const body = document.body;

    toggleSwitch.onclick = () => {
        if (body.style.backgroundColor == "") {
            body.style.backgroundColor = "black";
            toggleSwitch.style.backgroundColor = "white";
            toggleSwitchText.innerHTML = "Encender";
            toggleSwitchText.style.color = "black";
        } else if (body.style.backgroundColor == "white") {
            body.style.backgroundColor = "black";
            toggleSwitch.style.backgroundColor = "white";
            toggleSwitchText.innerHTML = "Encender";
            toggleSwitchText.style.color = "black";
        } else {
            body.style.backgroundColor = "white";
            toggleSwitch.style.backgroundColor = "black";
            toggleSwitchText.innerHTML = "Apagar";
            toggleSwitchText.style.color = "white";
        }
    }
}