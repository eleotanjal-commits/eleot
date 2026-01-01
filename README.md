# ELEOT - Smart Observation Tool

أداة المراقبة الذكية ELEOT - نظام تقييم شامل للمراقبة الصفية

## المميزات

- ✅ نظام تسجيل دخول احترافي (Supabase Auth)
- ✅ دعم كامل للغة العربية والإنجليزية (RTL/LTR)
- ✅ صفحة تقييم ELEOT كاملة مع جميع البيئات (A-G)
- ✅ حفظ وإدارة الزيارات في Supabase
- ✅ عرض تفاصيل الزيارات المحفوظة
- ✅ تصدير التقارير إلى PDF و Word
- ✅ واجهة مستخدم حديثة ومتجاوبة

## التقنيات المستخدمة

- **React 18** - مكتبة واجهة المستخدم
- **Vite** - أداة البناء السريعة
- **React Router** - التوجيه والتنقل
- **Supabase** - قاعدة البيانات والمصادقة
- **TailwindCSS** - تصميم الواجهة
- **jsPDF** - تصدير PDF

## متطلبات التشغيل

1. Node.js (الإصدار 18 أو أحدث)
2. حساب Supabase مع مشروع نشط

## خطوات الإعداد

### 1. تثبيت الحزم

```bash
npm install
```

### 2. إعداد Supabase

1. أنشئ مشروع جديد في [Supabase](https://app.supabase.com)
2. اذهب إلى **Settings → API**
3. انسخ **Project URL** و **anon/public key**

### 3. إنشاء ملف البيئة

أنشئ ملف `.env` في المجلد الرئيسي:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### 4. إعداد قاعدة البيانات

في Supabase Dashboard، أنشئ جدول `visits`:

```sql
CREATE TABLE visits (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  teacher_name TEXT,
  observation_text TEXT,
  selected_criteria TEXT[],
  selected_sections TEXT[],
  results JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;

-- Create policy for users to see only their own visits
CREATE POLICY "Users can view own visits" ON visits
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own visits" ON visits
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own visits" ON visits
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own visits" ON visits
  FOR DELETE USING (auth.uid() = user_id);
```

### 5. إعداد المصادقة

في Supabase Dashboard:

1. اذهب إلى **Authentication → Providers**
2. فعّل **Email** provider
3. (اختياري) فعّل **Google** provider وأضف Client ID و Secret
4. في **Authentication → URL Configuration**:
   - أضف `http://localhost:5173` إلى **Redirect URLs**

## تشغيل المشروع

```bash
npm run dev
```

المشروع سيعمل على `http://localhost:5173`

## بناء المشروع للإنتاج

```bash
npm run build
```

الملفات المبنية ستكون في مجلد `dist`

## هيكل المشروع

```
src/
├── components/          # المكونات المشتركة
│   ├── Layout.jsx      # التخطيط العام
│   ├── Navbar.jsx      # شريط التنقل
│   └── ProtectedRoute.jsx  # حماية المسارات
├── contexts/           # Context API
│   ├── AuthContext.jsx    # سياق المصادقة
│   └── LanguageContext.jsx # سياق اللغة
├── pages/              # صفحات التطبيق
│   ├── Login.jsx       # صفحة تسجيل الدخول
│   ├── Observation.jsx # صفحة التقييم
│   ├── Visits.jsx      # قائمة الزيارات
│   ├── VisitView.jsx   # عرض زيارة
│   ├── Reports.jsx     # التقارير
│   └── Settings.jsx    # الإعدادات
├── services/           # الخدمات
│   ├── supabase.js     # إعداد Supabase
│   ├── supabaseService.js # عمليات قاعدة البيانات
│   └── aiService.js    # خدمة التقييم
├── config/             # الإعدادات
│   └── eleotConfig.js  # إعدادات ELEOT
└── utils/              # الأدوات المساعدة
    └── exportUtils.js  # تصدير PDF/Word
```

## الصفحات المتاحة

- `/login` - تسجيل الدخول
- `/observation` - صفحة التقييم الرئيسية
- `/visits` - قائمة الزيارات المحفوظة
- `/visits/:id` - عرض تفاصيل زيارة
- `/reports` - التقارير (قيد التطوير)
- `/settings` - الإعدادات

## الميزات الرئيسية

### 1. نظام التقييم ELEOT

- 7 بيئات تعليمية (A-G)
- 28 معيار تقييم شامل
- حساب تلقائي للدرجات
- توصيات مبنية على النتائج

### 2. إدارة الزيارات

- حفظ الزيارات مع جميع التفاصيل
- البحث والفلترة
- عرض تفاصيل كاملة لكل زيارة
- حذف الزيارات

### 3. التصدير

- تصدير إلى PDF
- تصدير إلى Word
- نسخ النتائج إلى الحافظة

### 4. دعم اللغات

- العربية (RTL)
- الإنجليزية (LTR)
- تبديل سهل بين اللغات
- حفظ تفضيلات اللغة

## المساهمة

المشروع مفتوح للمساهمة والتطوير.

## الترخيص

جميع الحقوق محفوظة © 2024


