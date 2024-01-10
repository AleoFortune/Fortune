import { useNavigate } from 'react-router-dom';
import Button from '@components/Button';
import TotalWinnings from '@components/TotalWinnings';
import TheirTurn from '@components/TheirTurn';
import YourTurn from '@components/YourTurn';
import { useGameStore } from '@state/gameStore';
import { useNewGameStore } from './NewGame/store';
import { requestCreateEvent,getEvent ,useAccount, GetEventResponse, getAccount, GetSelectedAccountResponse, PuzzleAccount, GetEventsResponse, EventsFilter} from '@puzzlehq/sdk';
import { EventType } from '@puzzlehq/types';
import { useState } from 'react';

function Home() {

  const [yourTurn, theirTurn, totalBalance] = useGameStore((state) => [
    state.yourTurn,
    state.theirTurn,
    state.totalBalance,
  ]);
  // const [account, setAccount] = useState<PuzzleAccount | undefined>();

  const [initialize] = useNewGameStore((state) => [state.initialize]);
  const { account } = useAccount();
  const record1 = {bet_amount:'20u64', bet:'2u32'};
  const navigate = useNavigate();

const testGetAccount = async () => {
  console.log(account?.address);
}

const testGetMap = async () => {
  // Define the URL of the endpoint
  const url = `https://api.explorer.aleo.org/v1/testnet3/program/cassino_game_test_fp.aleo/mapping/account/${account?.address}`;
  

  try {
      // Use the fetch API to send a GET request
      const response = await fetch(url);

      // Check if the response is ok (status in the range 200-299)
      if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
      }

      // Process the JSON data
      const data = await response.json();

      console.log(data); // Log or process the data as needed
  } catch (error) {
      console.error('There was a problem with the fetch operation:', error);
  }
}


const testEvent = async () => {

const createEventResponse = await requestCreateEvent({
  type: EventType.Execute,
  programId:"cassino_game_test_fp.aleo",
  functionId:"make_dozen_bet_public",
  fee:1.5,
  inputs:Object.values(record1),
  
})
if(createEventResponse.error){
  alert(createEventResponse.error)
}else {
  alert(createEventResponse.eventId)
}

}

const getEventResponseTest = async () => {
  try {
    const response: GetEventResponse = await getEvent({
      id: "659eb104ce397a383702322c",
      address: account?.address
    });
    alert(JSON.stringify(response.event));
  } catch (e) {
    alert((e as Error).message);
  } finally {
  }
  
}

const getAllEvents = async( ) => {
const filter: EventsFilter  = {
  type: EventType.Execute,
  programId:"cassino_game_test_ekim.aleo",
  functionId:"random_number_generate",
}


// try {
//   // const events:GetEventsResponse = await getEvents(filter)

//   console.log(events)
// } catch (error) {
  
// }

}


  return (
    <div className='flex h-full flex-col justify-between '>
      <div className='flex w-full flex-col gap-4 px-1'>
        <TotalWinnings amount={totalBalance} />
        <Button
          color='yellow'
          onClick={() => {
            if (!account) return;
            initialize(account?.address);
            navigate('/new-game');
          }}
          disabled={!account}
        >
          NEW GAME
        </Button>
        <Button color='green' onClick={()=>testGetAccount()}>TEST Account </Button>
        <Button color='green' onClick={()=>testEvent()}>TEST Event </Button>
        <Button color='green' onClick={()=>getEventResponseTest()}>get event </Button>
        <Button color='green' onClick={()=>testGetMap()}>get key from map </Button>


        {yourTurn.length > 0 && <YourTurn games={yourTurn} />}
        {theirTurn.length > 0 && <TheirTurn games={theirTurn} />}
        {yourTurn.length === 0 && theirTurn.length === 0 && (
          <p className='self-center font-semibold'>
            No ongoing games, start one with a friend!
          </p>
        )}
      </div>
      <div className='mt-4 px-4 pb-4 text-center'>
        {' '}
        {/* Adding px-4 back here to maintain padding for the bottom button */}
        <Button color='blue' size='sm'>
          Past Games
        </Button>
      </div>
    </div>
  );
    }

export default Home;
