import "./globals.css"; import type {Metadata} from "next";
export const metadata:Metadata={title:"USG Central",description:"University Student Government operations platform"};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body>{children}</body></html>}