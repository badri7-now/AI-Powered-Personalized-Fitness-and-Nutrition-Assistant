import 'react-native-url-polyfill/auto';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as SecureStore from 'expo-secure-store';
import { createClient } from '@supabase/supabase-js';

const url=process.env.EXPO_PUBLIC_SUPABASE_URL;
const key=process.env.EXPO_PUBLIC_SUPABASE_PUBLISHABLE_KEY;
if(!url||!key) console.warn('Supabase environment variables are not configured.');

const secureStorage={
 async getItem(k:string){try{return await SecureStore.getItemAsync(k)}catch{return AsyncStorage.getItem(k)}},
 async setItem(k:string,v:string){try{await SecureStore.setItemAsync(k,v)}catch{await AsyncStorage.setItem(k,v)}},
 async removeItem(k:string){try{await SecureStore.deleteItemAsync(k)}catch{} await AsyncStorage.removeItem(k)}
};
export const supabase=createClient(url||'https://placeholder.supabase.co',key||'placeholder-key',{auth:{storage:secureStorage,autoRefreshToken:true,persistSession:true,detectSessionInUrl:false}});
