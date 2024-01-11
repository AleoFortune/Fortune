/* eslint-disable @typescript-eslint/no-explicit-any */
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";
import { PuzzleWalletProvider } from "@puzzlehq/sdk";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <div className="h-screen w-screen">
    <PuzzleWalletProvider
      dAppName="Aleo Fortune"
      dAppDescription="A Roulette Game"
      dAppUrl=""
      dAppIconURL=""
    >
      <App />
    </PuzzleWalletProvider>
  </div>
);
