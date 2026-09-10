import { createServerClient } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';

export async function middleware(request: NextRequest) {
 let response = NextResponse.next({ request });
 const supabase = createServerClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!, { cookies:{ getAll:()=>request.cookies.getAll(), setAll:(cookies)=>cookies.forEach(({name,value,options})=>response.cookies.set(name,value,options)) } });
 const { data:{ user } } = await supabase.auth.getUser();
 const path=request.nextUrl.pathname;
 const privatePath=['/dashboard','/workouts','/exercises','/nutrition','/progress','/coach','/calorie-calculator','/profile','/settings','/admin','/onboarding'].some(p=>path===p||path.startsWith(p+'/'));
 if(privatePath && !user) return NextResponse.redirect(new URL('/login',request.url));
 if(user && ['/login','/signup'].includes(path)) return NextResponse.redirect(new URL('/dashboard',request.url));
 return response;
}
export const config={matcher:['/((?!_next/static|_next/image|favicon.ico).*)']};
