#include <cstddef>
#include <iostream>
#include <memory>
#include <vector>

template <class T>
struct custom_allocator {
	typedef T value_type;
	custom_allocator() noexcept {}
	template <class U> custom_allocator(const custom_allocator<U>&) {}
	T* allocate (std::size_t n) {
		return static_cast<T*>(::new(n*sizeof(T)));
	}
	void deallocate (T* p, std::size_t n) {
		::delete(p);
	}
};