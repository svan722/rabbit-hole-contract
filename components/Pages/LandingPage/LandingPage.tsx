import Layout from "@/components/Layout"
import SeoHead from "@/components/SeoHead"
import Total from "./Total/Total"

const LandingPage = () => (
  <Layout type="base">
    <SeoHead />
    <div className="w-full bg-white_1">
      <Total />
    </div>
  </Layout>
)

export default LandingPage
