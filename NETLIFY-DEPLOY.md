# تعليمات النشر على Netlify

## طريقة Drag and Drop (سريعة)

### الخطوات:

1. **بناء المشروع محلياً:**
   ```bash
   npm run build
   ```
   هذا سينشئ مجلد `dist` يحتوي على الملفات المبنية.

2. **الذهاب إلى Netlify:**
   - افتح [Netlify Drop](https://app.netlify.com/drop)
   - أو اذهب إلى Dashboard → Sites → Add new site → Deploy manually

3. **سحب وإفلات مجلد `dist`:**
   - اسحب مجلد `dist` من المشروع
   - أفلته في منطقة Drop في Netlify
   - سيبدأ النشر تلقائياً

4. **إعداد Environment Variables:**
   - بعد النشر، اذهب إلى Site settings → Environment variables
   - أضف المتغيرات التالية:
     ```
     VITE_SUPABASE_URL=your-supabase-url
     VITE_SUPABASE_ANON_KEY=your-supabase-key
     OPENAI_API_KEY=your-openai-key
     ```

5. **إعادة النشر:**
   - بعد إضافة Environment Variables، أعد النشر مرة أخرى

## طريقة Git (موصى بها للمشاريع المستمرة)

### الخطوات:

1. **ربط المستودع:**
   - ادفع الكود إلى GitHub/GitLab/Bitbucket
   - في Netlify: Add new site → Import from Git
   - اختر المستودع

2. **إعدادات البناء:**
   - Build command: `npm run build`
   - Publish directory: `dist`
   - (هذه موجودة في `netlify.toml`)

3. **Environment Variables:**
   - أضف نفس المتغيرات المذكورة أعلاه

## ملاحظات مهمة:

### ✅ ما يتم تضمينه في النشر:
- مجلد `dist` (الملفات المبنية)
- ملف `netlify.toml` (إعدادات Netlify)
- مجلد `netlify/functions` (Netlify Functions)

### ❌ ما لا يتم تضمينه:
- `node_modules` (يتم تثبيتها أثناء البناء)
- `.env` (يجب إضافتها كـ Environment Variables في Netlify)
- ملفات المصدر `src/` (يتم بناؤها إلى `dist`)

### 🔧 Netlify Functions:

الـ Function `ai-evaluate` سيعمل تلقائياً على:
```
https://your-site.netlify.app/.netlify/functions/ai-evaluate
```

### 📝 Checklist قبل النشر:

- [ ] تم بناء المشروع بنجاح (`npm run build`)
- [ ] مجلد `dist` موجود ويحتوي على الملفات
- [ ] `netlify.toml` موجود
- [ ] `netlify/functions/ai-evaluate.js` موجود
- [ ] تم إعداد Environment Variables في Netlify:
  - [ ] `VITE_SUPABASE_URL`
  - [ ] `VITE_SUPABASE_ANON_KEY`
  - [ ] `OPENAI_API_KEY`
- [ ] تم إعداد قاعدة البيانات Supabase
- [ ] تم تشغيل SQL migration في Supabase

### 🚀 بعد النشر:

1. اختبر الصفحات:
   - `/login` - تسجيل الدخول
   - `/observation` - صفحة التقييم
   - `/visits` - قائمة الزيارات
   - `/reports` - التقارير

2. اختبر AI Function:
   - اذهب إلى `/observation`
   - أدخل بيانات زيارة
   - اضغط "قيّم باستخدام الذكاء الاصطناعي"
   - تأكد من أن التقييم يعمل

3. اختبر قاعدة البيانات:
   - احفظ زيارة جديدة
   - تأكد من ظهورها في `/visits`

## استكشاف الأخطاء:

### المشكلة: الموقع لا يعمل
- تحقق من أن `dist` تم بناؤه بشكل صحيح
- تحقق من Console في المتصفح للأخطاء
- تحقق من Netlify Deploy Logs

### المشكلة: Environment Variables لا تعمل
- تأكد من إعادة النشر بعد إضافة المتغيرات
- تحقق من أن الأسماء صحيحة (حساسة لحالة الأحرف)
- تحقق من Netlify Function Logs

### المشكلة: AI Function لا يعمل
- تحقق من أن `OPENAI_API_KEY` موجودة
- تحقق من Netlify Function Logs
- تأكد من أن الـ Function موجودة في `netlify/functions/`

### المشكلة: Supabase لا يعمل
- تحقق من `VITE_SUPABASE_URL` و `VITE_SUPABASE_ANON_KEY`
- تأكد من أن RLS policies مفعلة
- تحقق من Console للأخطاء

## روابط مفيدة:

- [Netlify Dashboard](https://app.netlify.com)
- [Netlify Functions Docs](https://docs.netlify.com/functions/overview/)
- [Supabase Dashboard](https://app.supabase.com)

