import React from "react"

const GasolineGauge: React.FC = () => (
  <div className="panel">
    <input
      className="w-full m-[4.8px] 3md:m-[8px] p-[2.4px_1.8px_2.8px_6.6px] sm:p-[4px_3px_4px_11px]
       rounded-[3.6px] sm:rounded-[6px] 
        outline-0 !focus:border-green !ring-0 appearance-none
        text-sm md:text-base
        transition duration-[300ms] hover:scale-[1.01]"
      type="number"
      min={1}
    />
  </div>
)

export default GasolineGauge
