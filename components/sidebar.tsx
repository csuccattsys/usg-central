"use client";
import Link from "next/link";
import {usePathname} from "next/navigation";
import {LayoutDashboard,ClipboardList,CalendarDays,FileText,Users,HeartHandshake,Wallet,Package,BarChart3,Scale,Megaphone,Building2,Settings,UserRound,LogOut} from "lucide-react";
const groups=[
["OVERVIEW",[["Dashboard","/dashboard",LayoutDashboard]]],
["OPERATIONS",[["Tasks","/dashboard/tasks",ClipboardList],["Activities","/dashboard/activities",CalendarDays],["Meetings","/dashboard/meetings",Users],["Documents","/dashboard/documents",FileText]]],
["STUDENT SERVICES",[["Student Concerns","/dashboard/concerns",HeartHandshake],["Announcements","/dashboard/announcements",Megaphone]]],
["FINANCE & PROPERTY",[["Finance","/dashboard/finance",Wallet],["Inventory","/dashboard/inventory",Package]]],
["GOVERNANCE",[["Governance Registry","/dashboard/governance",Scale],["Departments","/dashboard/departments",Building2],["Strategic Scorecard","/dashboard/scorecard",BarChart3]]],
["ADMINISTRATION",[["Users & Roles","/dashboard/users",UserRound],["Settings","/dashboard/settings",Settings]]]
];
export function Sidebar(){const path=usePathname();return <aside className="sidebar"><div className="brand"><div className="brandmark">USG</div><div><b>USG Central</b><div style={{fontSize:10,color:"#aebbd0"}}>Operations Portal</div></div></div>{groups.map(([g,items])=><div key={g as string}><div className="navtitle">{g as string}</div>{(items as any[]).map(([n,h,I])=><Link className={"navitem "+(path===h?"active":"")} href={h} key={n}><I size={16}/>{n}</Link>)}</div>)}<div className="navtitle">ACCOUNT</div><Link className="navitem" href="/"><LogOut size={16}/>Exit Portal</Link></aside>}
