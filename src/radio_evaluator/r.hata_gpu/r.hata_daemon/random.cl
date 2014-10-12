typedef struct { ulong a, b, c; } random_state;

unsigned long random(random_state *r)
{
    unsigned long old = r->b;
    r->b = r->a * 1103515245 + 12345;
    r->a = (~old ^ (r->b >> 3)) - r->c++;
    return r->b;
}

float random_01(random_state *r)
{
    return (random(r) & 4294967295) / 4294967295.0f;
}

void seed_random(random_state *r, ulong seed)
{
    r->a = seed;
    r->b = 0;
    r->c = 362436;
}

