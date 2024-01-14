// imports the decalartions package,
// where the connection between frontend and backend is made
import { learn_defi_backend } from "../../declarations/learn_defi_backend";

// event-listener to handle onLoad event
// async callback required because Motoko Query is async, hence a promise is returned.
// thus, to make the function await we make async
window.addEventListener("load", async () => {
  // console.log("Finished load");
  getBalanceFromBackendAndUpdateCurrentBalance();
});

// listen for submit event on form
document.querySelector("form").addEventListener("submit", async (event) => {
  // prevent default action of reload
  event.preventDefault();

  // get button to disable after submission
  const button = event.target.querySelector("#submit-btn");

  const topUpAmount = document.getElementById("input-amount").value;
  const withdrawAmount = document.getElementById("withdrawal-amount").value;
  // console.log(topUpAmount, withdrawAmount);

  // disable button
  button.setAttribute("disabled", true);

  // update only if there is some value, otherwise code messes
  if (topUpAmount.length != 0) {
    // accepts float in motoko backend --> see .did file
    await learn_defi_backend.topUp(parseFloat(topUpAmount));
  }

  if (withdrawAmount.length != 0) {
    // accepts float in motoko backend --> see .did file
    await learn_defi_backend.withdraw(parseFloat(withdrawAmount));
  }

  // compound either topUp, withdraw, or just check
  await learn_defi_backend.compound();

  getBalanceFromBackendAndUpdateCurrentBalance();

  // clear values
  document.getElementById("input-amount").value = "";
  document.getElementById("withdrawal-amount").value = "";

  // enable button
  button.removeAttribute("disabled");
});

async function getBalanceFromBackendAndUpdateCurrentBalance() {
  // call to motoko query
  const currentAmount = await learn_defi_backend.checkBalance();
  //  round to two decimal places
  document.getElementById("value").innerText =
    Math.round(currentAmount * 100) / 100;
}
