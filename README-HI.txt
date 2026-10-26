SUKUNA • GitHub + Netlify + Supabase starter
============================================

यह संस्करण मूल PHP/CodeIgniter + MySQL प्रोजेक्ट को सीधे PHP में चलाने के बजाय एक नए static frontend और Supabase Auth/Postgres पर आधारित है। यह मूल PHP app का 1:1 port नहीं है। पुरानी ZIP के गेम-cheat/aim-related switches और native library endpoints को इस starter में शामिल नहीं किया गया है।

फाइलें
------
index.html           Responsive SUKUNA login/register/user/admin UI
config.js            अपने Supabase project URL और public anon/publishable key डालें
supabase-schema.sql  Profiles table, signup trigger और RLS policies
netlify.toml         Netlify publish folder और basic security headers

सेटअप (मोबाइल पर भी)
-------------------
1) Supabase पर नया project बनाएं: https://supabase.com/dashboard
2) Project Settings / API से Project URL और anon/publishable key कॉपी करें। Service role key कभी browser में न डालें।
3) config.js खोलकर YOUR_PROJECT_REF और YOUR_ANON_OR_PUBLISHABLE_KEY बदलें।
4) Supabase SQL Editor में supabase-schema.sql का पूरा SQL चलाएं।
5) Authentication > URL Configuration में अपनी Netlify URL को Site URL और Redirect URLs में जोड़ें।
6) ZIP extract करें और सभी files को GitHub repository के root में upload करें।
7) Netlify में Add new project > Import an existing project > GitHub चुनें। Build command खाली रखें और Publish directory `.` रखें। Deploy करें। Official guide: https://docs.netlify.com/start/quickstarts/deploy-from-repository/
8) वेबसाइट खोलकर Register करें और email confirmation पूरा करें।
9) Admin बनाने के लिए Supabase SQL Editor में नीचे का SQL चलाएं (अपना email लगाएं):
   update public.profiles p set role = 'admin'
   from auth.users u where p.id = u.id and u.email = 'YOUR_EMAIL_ADDRESS';
10) Logout/login करें; Admin User Directory दिखना चाहिए।

महत्वपूर्ण सुरक्षा नोट्स
-----------------------
- `config.js` में केवल public anon/publishable key रखें; service_role/secret key कभी commit न करें।
- GitHub repository public हो तो इसमें कोई password, service key या निजी डेटा न रखें।
- इस starter का admin panel registered profiles की सूची दिखाता है; पुराने PHP panel की हर feature, keys, server library, payment/referral flow आदि स्वतः migrate नहीं हुए हैं।
- User directory privacy के लिए दूसरे users के email जानबूझकर UI में नहीं दिखाए जाते।
- Supabase project credentials जोड़े बिना Login/Register काम नहीं करेगा।
