import Button from "./Button";

function TotalWinnings({ amount }: { amount: number }) {
  return (
    <section className="mt-8 flex justify-between  self-stretch border-2 border-solid border-[color:var(--primary-green,#4EC331)] px-2.5 pt-3.5 text-primary-green">
      <div
        className="overflow-hidden text-left text-4xl font-bold tabular-nums"
        style={{ direction: "rtl" }}
      >
        {amount}
        <p className="font-medium text-base">Fortune Credits Available</p>
      </div>
      <div className="flex w-min">
        <Button size="sm" color="white">
          Add More
        </Button>
      </div>
    </section>
  );
}

export default TotalWinnings;
