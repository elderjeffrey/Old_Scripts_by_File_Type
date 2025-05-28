def o(p):
    def q():
        return '*' * p
    return q


r = o(1)
s = o(2)
print(r() + s())

b = bytearray(3)
print(b)

from datetime import date

date_1 = date(1992, 1, 16)
date_2 = date(1991, 2, 5)

print(date_1 - date_2)

from datetime import datetime

datetime = datetime(2019, 11, 27, 11, 27, 22)
print(datetime.strftime('%y/%B/%d %H:%M:%S'))
import calendar

print(calendar.weekheader(2))


try:
    raise Exception
except BaseException:
    print("a")
except Exception:
    print("b")
except:
    print("c")


x = "\\\\"
print(len(x))

print(chr(ord('p') + 2))
print(float("1.3"))



