-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.menu_items (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  meal_type text NOT NULL CHECK (meal_type = ANY (ARRAY['lunch'::text, 'dinner'::text])),
  is_available boolean DEFAULT true,
  created_by uuid,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT menu_items_pkey PRIMARY KEY (id),
  CONSTRAINT menu_items_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id)
);
CREATE TABLE public.orders (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  menu_item_id uuid NOT NULL,
  order_date date NOT NULL,
  meal_type text NOT NULL CHECK (meal_type = ANY (ARRAY['lunch'::text, 'dinner'::text])),
  quantity integer DEFAULT 1 CHECK (quantity > 0),
  amount_paid numeric DEFAULT 100 CHECK (amount_paid >= 0::numeric),
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id),
  CONSTRAINT orders_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL,
  display_name text NOT NULL,
  phone text,
  role text NOT NULL DEFAULT 'tenant'::text CHECK (role = ANY (ARRAY['admin'::text, 'accountant'::text, 'tenant'::text, 'chef'::text])),
  room_number text,
  balance numeric DEFAULT 0 CHECK (balance >= 0::numeric),
  is_approved boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
