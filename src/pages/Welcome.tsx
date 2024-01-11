import { useConnect, useAccount } from "@puzzlehq/sdk";
import rightImageSrc from "../assets/alex_mic_left_tilt.png";
import leftImageSrc from "../assets/alex_mic_right_tilt.png";
import bottomImageSrc from "../assets/alexbottom.png";
import { useNavigate } from "react-router-dom";
import { useEffect } from "react";
import Button from "@components/Button.js";

export const Welcome = () => {
  const navigate = useNavigate();
  const { account } = useAccount();
  const { loading, connect } = useConnect();

  useEffect(() => {
    if (account) {
      navigate("/");
    }
  }, [account, navigate]);

  return (
    <div className="flex h-full w-full items-stretch justify-between">
      <div className="relative flex h-full w-full flex-col items-center justify-center">
        <h1 className="text-24xl z-10 max-w-full overflow-visible whitespace-nowrap text-center font-extrabold leading-[40.56px] tracking-tight text-primary-white">
          Aleo Fortune
        </h1>
        <p className="z-10 mb-8 mt-8 max-w-[400px] text-center text-base font-bold tracking-tight text-primary-white">
          Connect your Wallet to play Roulette !
        </p>
        <Button
          className="max-w-[250px]"
          onClick={connect}
          color="yellow"
          disabled={loading}
        >
          {loading ? "Loading..." : loading ? "Connecting..." : "Connect!"}
        </Button>
      </div>
    </div>
  );
};
