# 🚀 نشر سريع على Netlify - Drag and Drop

## الخطوات السريعة:

### 1️⃣ ارفع المشروع الكامل:
- اذهب إلى: https://app.netlify.com/drop
- اسحب **المجلد الرئيسي** `eleot-web` (ليس فقط dist)
- أفلته في Netlify

### 2️⃣ انتظر البناء:
- Netlify سيقوم تلقائياً بـ:
  - تثبيت الحزم (`npm install`)
  - بناء المشروع (`npm run build`)
  - نشر الملفات

### 3️⃣ أضف Environment Variables:
بعد النشر، اذهب إلى:
**Site settings → Environment variables**

أضف:
```
VITE_SUPABASE_URL
VITE_SUPABASE_ANON_KEY
OPENAI_API_KEY
```

### 4️⃣ أعد النشر:
**Deploys → Trigger deploy → Redeploy site**

## ✅ كل شيء جاهز!

الموقع الآن متاح على: `https://your-site.netlify.app`

---

**ملاحظة:** تأكد من أن قاعدة البيانات Supabase جاهزة وتم تشغيل SQL migration.

