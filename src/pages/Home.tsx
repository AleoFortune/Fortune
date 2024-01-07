import { useNavigate } from 'react-router-dom';
import Button from '@components/Button';
import TotalWinnings from '@components/TotalWinnings';
import TheirTurn from '@components/TheirTurn';
import YourTurn from '@components/YourTurn';
import { useGameStore } from '@state/gameStore';
import { useNewGameStore } from './NewGame/store';
import { requestCreateEvent,getEvent ,useAccount, GetEventResponse} from '@puzzlehq/sdk';
import { EventType } from '@puzzlehq/types';
import { useState } from 'react';

function Home() {
  const [yourTurn, theirTurn, totalBalance] = useGameStore((state) => [
    state.yourTurn,
    state.theirTurn,
    state.totalBalance,
  ]);
  const [initialize] = useNewGameStore((state) => [state.initialize]);
  const { account } = useAccount();
  const record1 = { player: 'aleo19jp6rwmzq4m2nj32h8fmtecl4hyclajxnzx4plksgsp3qtcsaygqdk68dr'};

  const navigate = useNavigate();

const testEvent = async () => {

const createEventResponse = await requestCreateEvent({
  type: EventType.Execute,
  programId:"cassino_game_test_30.aleo",
  functionId:"random_number_generate",
  fee:5,
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
      id: "659ab230c918ed9ed0d45aae",
      address: "aleo19jp6rwmzq4m2nj32h8fmtecl4hyclajxnzx4plksgsp3qtcsaygqdk68dr"
    });
    alert(JSON.stringify(response.event!.status));
  } catch (e) {
    alert((e as Error).message);
  } finally {
    console.log("bitti")
  }
  
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
        <Button color='green' onClick={()=>testEvent()}>TEST </Button>
        <Button color='green' onClick={()=>getEventResponseTest()}>get event </Button>

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
