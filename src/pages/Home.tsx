import { useNavigate } from "react-router-dom";
import Button from "@components/Button";
import TotalWinnings from "@components/TotalWinnings";
import TheirTurn from "@components/TheirTurn";
import YourTurn from "@components/YourTurn";
import { useGameStore } from "@state/gameStore";
import { useNewGameStore } from "./NewGame/store";
import {
  requestCreateEvent,
  getEvent,
  useAccount,
  GetEventResponse,
  GetEventsResponse,
  EventsFilter,
  getEvents,
} from "@puzzlehq/sdk";
import { EventType } from "@puzzlehq/types";

function Home() {
  const [yourTurn, theirTurn, totalBalance] = useGameStore((state) => [
    state.yourTurn,
    state.theirTurn,
    state.totalBalance,
  ]);
  // const [account, setAccount] = useState<PuzzleAccount | undefined>();

  const [initialize] = useNewGameStore((state) => [state.initialize]);
  const { account } = useAccount();
  const record1 = { bet_amount: "20u64", bet: "2u32" };
  const navigate = useNavigate();
  const input = {
    reciever: "aleo1696yxs062yrm0nmvflwcp7zjy0l8l4w8gpr3wn0ql3nttu54ayqsuxqus5",
    amount: "10u64",
  };

  const testGetAccount = async () => {
    console.log(account?.address);
  };

  const testGetMapBalance = async () => {
    const url = `https://api.explorer.aleo.org/v1/testnet3/program/cassino_game_test_fp.aleo/mapping/account/${account?.address}`;
    try {
      const response = await fetch(url);
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      const data = await response.json();
      console.log(data); // Log or process the data as needed
    } catch (error) {
      console.error("There was a problem with the fetch operation:", error);
    }
  };

  const testEvent = async () => {
    const createEventResponse = await requestCreateEvent({
      type: EventType.Execute,
      programId: "cassino_game_test_fp.aleo",
      functionId: "make_dozen_bet_public",
      fee: 1.5,
      inputs: Object.values(record1),
    });
    if (createEventResponse.error) {
      alert(createEventResponse.error);
    } else {
      alert(createEventResponse.eventId);
    }
  };

  const depositCredit = async () => {
    if (!account) {
      alert("no account");
      return;
    }
    const fields = { receiver: account?.address, amount: "100u64" };

    const createEventResponse = await requestCreateEvent({
      type: EventType.Execute,
      programId: "cassino_game_test_fp.aleo",
      functionId: "deposit_public",
      fee: 1.5,
      inputs: Object.values(fields),
    });
    if (createEventResponse.error) {
      alert(JSON.stringify(createEventResponse));
    } else {
      alert(JSON.stringify(createEventResponse));
      console.log(createEventResponse);
    }
  };

  const testTransferPublic = async () => {
    const createEventResponse = await requestCreateEvent({
      type: EventType.Execute,
      programId: "credits.aleo",
      functionId: "transfer_public",
      fee: 3,
      inputs: Object.values(input),
    });
    if (createEventResponse.error) {
      alert(createEventResponse.error);
    } else {
      alert(createEventResponse.eventId);
    }
  };

  const playKumar = async () => {
    let playInput = { bet_amount: "10u64", bet: "0u32" };

    const createEventResponse = await requestCreateEvent({
      type: EventType.Execute,
      programId: "cassino_game_test_fp.aleo",
      functionId: "make_odd_even_bet_public",
      fee: 1.5,
      inputs: Object.values(playInput),
    });
    if (createEventResponse.error) {
      alert(JSON.stringify(createEventResponse.error));
    } else {
      alert(JSON.stringify(createEventResponse.eventId));
    }
  };

  const getEventResponseTest = async () => {
    try {
      const response: GetEventResponse = await getEvent({
        id: "659eb104ce397a383702322c",
        address: account?.address,
      });
      alert(JSON.stringify(response.event));
    } catch (e) {
      alert((e as Error).message);
    } finally {
    }
  };

  const getAllEvents = async () => {
    const filter: EventsFilter = {
      type: EventType.Execute,
      programId: "cassino_game_test_fp.aleo",
      functionId: "make_odd_even_bet_public",
    };

    try {
      const events: GetEventsResponse = await getEvents(filter);

      console.log(events);
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <div className="flex h-full flex-col justify-between ">
      <div className="flex w-full flex-col gap-4 px-1">
        <TotalWinnings amount={totalBalance} />
        <Button
          color="yellow"
          onClick={() => {
            if (!account) return;
            initialize(account?.address);
            navigate("/new-game");
          }}
          disabled={!account}
        >
          NEW GAME
        </Button>
        <Button color="green" onClick={() => testGetAccount()}>
          TEST Account{" "}
        </Button>
        <Button color="green" onClick={() => testEvent()}>
          TEST Event{" "}
        </Button>
        <Button color="green" onClick={() => getEventResponseTest()}>
          get event{" "}
        </Button>
        <Button color="green" onClick={() => getAllEvents()}>
          GET ALL EVENTS
        </Button>
        <Button color="green" onClick={() => testGetMapBalance()}>
          get key from map{" "}
        </Button>
        <Button color="green" onClick={() => testTransferPublic()}>
          transfer public{" "}
        </Button>
        <Button color="green" onClick={() => depositCredit()}>
          Deposit 100 Credit
        </Button>
        <Button color="green" onClick={() => playKumar()}>
          Rastgele{" "}
        </Button>

        {yourTurn.length > 0 && <YourTurn games={yourTurn} />}
        {theirTurn.length > 0 && <TheirTurn games={theirTurn} />}
        {yourTurn.length === 0 && theirTurn.length === 0 && (
          <p className="self-center font-semibold">
            No ongoing games, start one with a friend!
          </p>
        )}
      </div>
      <div className="mt-4 px-4 pb-4 text-center">
        {" "}
        {/* Adding px-4 back here to maintain padding for the bottom button */}
        <Button color="blue" size="sm">
          Past Games
        </Button>
      </div>
    </div>
  );
}

export default Home;
